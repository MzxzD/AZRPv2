//
//  ChatViewModel.swift
//  AZRPv2
//
//  Created by Mateo Doslic on 05/01/2019.
//  Copyright © 2019 Mateo Doslic. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import Starscream
import Alamofire


typealias Coordinates = (longitude: Double, latitude: Double)

class ChatViewModel: ChatViewModelProtocol {
    
    var room: Room
    var username: String = .empty
    weak var coordinatorDelegate: ChatCoordinatorDelegate?
    var socketController: WebSocketController
    
    init(room: Room, socket : WebSocketController) {
        self.room = room
        self.socketController = socket
        self.username = getUsernameFromData()
    }
    func openImagePicker(imagePicker: UIImagePickerController) {
        coordinatorDelegate?.presentImagePicker(imagePicker: imagePicker)
    }
    
    
    func sortChatBubbles(messagePosition: Int) -> Bool {
        let message = self.room.messages[messagePosition]
        if message.sender == self.username {
            return true
        }else {
            return false
        }
    }
    
    func sendMessage(message: String?, image: UIImage?, coordinates: Coordinates?) {
        if validateInputData(message: message, image: image, coordinates: coordinates){
            let message = prepareMessageToSend(message: message, image: image, coordinates: coordinates)
            let messageToSend = prepareObjectForSending(message: message)
//            self.socketController.socket.write(string: messageToSend)
        }else {
            print("No items added")
        }
    }
    
}

extension ChatViewModel {
    
    private func validateInputData(message: String?, image: UIImage?, coordinates: Coordinates?) -> Bool{
        if (message == .empty && image == nil && coordinates == nil){
            return false
        }
        return true
        
    }
    
    private func prepareMessageToSend(message: String?, image: UIImage?, coordinates: Coordinates?) -> SendMessageRequest {
        var attributes = Attr()
        attributes.room = self.room.id
        attributes.object = ObjectType.message.rawValue
        attributes.senderUnique = self.username + "_" + randomString(length: 4)
        if message != nil {
            attributes.content = message
        }
        if image != nil {
            // STILL IN PROGRESS
            
            uploadImage(image: image!, progress: { (progressPersentage) -> (Void) in
                while !progressPersentage.isFinished {
                    print(progressPersentage.fractionCompleted)
                }
            }) { (imageObject) -> (Void) in
                attributes.file = imageObject.file?.id
            }
        }
        if coordinates != nil {
            let location = Location(latitude: (coordinates?.latitude)!, longitude: (coordinates?.longitude)!)
            attributes.location = location
        }
        
        var message = SendMessageRequest()
        message.type = SendMessageType.create.rawValue
        message.attr = attributes
        return message
    }
    
    private func prepareObjectForSending(message: SendMessageRequest) -> String {
        let jsonEncoder = JSONEncoder()
        let jsonData = try! jsonEncoder.encode(message)
        guard let json = String(data: jsonData, encoding: String.Encoding.utf8) else {return .empty}
        return json
    }
    
    func websocketDidConnect(socket: WebSocketClient) {
        print("websocket is connected")
    }
    
    func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
        print("websocket is disconnected: \(String(describing: error?.localizedDescription))")
        print("trying to recoonect")
        socketController.socket.connect()
    }
    
    func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
        //        let responseData = text.data(using: String.Encoding.utf8)
        print(text)
    }
    
    func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
        
    }
    
}

protocol ChatViewModelProtocol: CollectionViewCellDelegate, WebSocketDelegate, SendMessageDelegate {
    var room: Room {get}
    func openImagePicker(imagePicker: UIImagePickerController)
    var coordinatorDelegate: ChatCoordinatorDelegate? {get set}
}

public protocol CollectionViewCellDelegate: class {
    func sortChatBubbles(messagePosition: Int) -> Bool
}

protocol SendMessageDelegate: class {
    func sendMessage(message: String?, image: UIImage?, coordinates: Coordinates?)
    
}

public protocol LocationDelegate: class {
    func getLocation()
}

public protocol ImageDelegate: class {
    func getImage()
}

public func getUsernameFromData() -> String {
    var user: NSManagedObject!
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return .empty }
    let managedContext = appDelegate.persistentContainer.viewContext
    let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "AZRPUser")
    do {
        user = try managedContext.fetch(fetchRequest).first
    } catch let error as NSError {
        print("Error occured while fetching items", error)
    }
    
    return user.value(forKey: "username") as! String
    
}

public func getUserIDFromData() -> Int {
    var user: NSManagedObject!
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return -1 }
    let managedContext = appDelegate.persistentContainer.viewContext
    let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "AZRPUser")
    do {
        user = try managedContext.fetch(fetchRequest).first
    } catch let error as NSError {
        print("Error occured while fetching items", error)
    }
    
    return user.value(forKey: "id") as! Int
    
}


func uploadImage(image: UIImage,  progress: @escaping (Progress) -> (Void) , completion : @escaping (ImageObject)-> (Void)) {
    var responsePackage = ImageObject(file: nil)
    guard let  imageJPEG = image.jpegData(compressionQuality: 0.75) else {
        print("Unable to get JPEG representation for image \(image)")
        return
    }
    let token = getTokenFromData()
    let tokenData = token.data(using: String.Encoding.utf8)
    let uploadURL = URL(string: "http://0.0.0.0:8000/api/files/upload/")
    
    //    let parameters = ["name": "rname"] //Optional for extra parameter
    Alamofire.upload(multipartFormData: { multipartFormData in
        multipartFormData.append(imageJPEG, withName: "file", fileName: "file"+randomString(length: 4)+".jpg", mimeType: "application/octet-stream")
        multipartFormData.append(tokenData!, withName: "token")
//            .append(imageJPEG, withName: "file"+randomString(length: 4)+".jpg")
  
    },to:uploadURL!, method:.put)
    { (result) in
        switch result {
        case .success(let upload, _, _):
            print("yeeey")
            upload.uploadProgress(closure: { (progressUpload) in
//                print("Upload Progress: \(progressUpload.fractionCompleted)")
                progress(progressUpload)
            })
            
            upload.responseString{ response in
                let decoder = JSONDecoder()
//                print(response)
                let responseJSON = response.data
//                print(response.result.value)
                do {
                    let data = try decoder.decode(ImageObject.self, from: responseJSON!)
                    responsePackage = data
                    print(data)
                } catch let error {
                    print(error.localizedDescription)
                }
                completion(responsePackage)
            }
            

        case .failure(let encodingError):
            print(encodingError)
        }
    }
    
}





struct ImageObject: Codable {
    let message: String = .empty
    let file: ImageFile?
}

struct ImageFile: Codable {
    let name, hash, size: String
    let url: String
    let id: Int
}
