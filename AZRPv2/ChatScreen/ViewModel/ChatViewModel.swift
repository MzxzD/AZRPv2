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
import Alamofire
import RxSwift


typealias Coordinates = (longitude: Double, latitude: Double)

class ChatViewModel: ChatViewModelProtocol {
    var username: String = .empty
    weak var coordinatorDelegate: ChatCoordinatorDelegate?
    var messages: [Messages] = []
    let delegate = UIApplication.shared.delegate as! AppDelegate
    var id: Int?
    var reinitALL: ReplaySubject<Bool>
    
    init(roomID: Int) {
        self.reinitALL = ReplaySubject<Bool>.create(bufferSize: 1)
        self.username = getUsernameFromData()
        getMessagesFromID(id: roomID)
    }
    func openImagePicker(imagePicker: UIImagePickerController) {
        coordinatorDelegate?.presentImagePicker(imagePicker: imagePicker)
    }
    
    func getMessagesFromID(id: Int) {
        let rooms = RealmSerivce().realm.objects(Room.self)
        for room in rooms {
            if id == room.id{
                for message in room.messages{
                    self.messages.append(message)
                }
            }
        }
        self.id = id
    }
    
    
    func reFetchDataFromRealm(){
        self.messages.removeAll()
        let rooms = RealmSerivce().realm.objects(Room.self)
        for room in rooms {
            if self.id == room.id{
                for message in room.messages{
                    self.messages.append(message)
                }
            }
        }
        
    }
    
    func sortChatBubbles(messagePosition: Int) -> Bool {
        let message = self.messages[messagePosition]
        if message.sender == self.username {
            return true
        }else {
            return false
        }
    }
    // TODO: CREATE event that waits for imageupload
    func sendMessage(message: String?, image: UIImage?, coordinates: Coordinates?) {
        if validateInputData(message: message, image: image, coordinates: coordinates){
            let message = prepareMessageToSend(message: message, image: image, coordinates: coordinates)
            let messageToSend = prepareObjectForSending(message: message)
            delegate.socketController.sendMessage(message: messageToSend)
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
        attributes.room = self.messages.last?.room ?? -1
        attributes.object = ObjectType.message.rawValue
        attributes.senderUnique = self.username + "_" + randomString(length: 4)
        if message != nil {
            attributes.content = message
        }
        if image != nil {
            uploadImage(image: image!, progress: { (progressPersentage) -> (Void) in
                while !progressPersentage.isFinished {
                    print("Upload Progress: \(progressPersentage.fractionCompleted)")
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
    
    
}

protocol ChatViewModelProtocol: CollectionViewCellDelegate, SendMessageDelegate {
    func openImagePicker(imagePicker: UIImagePickerController)
    var messages: [Messages] {get}
    var coordinatorDelegate: ChatCoordinatorDelegate? {get set}
    func reFetchDataFromRealm()
    var reinitALL: ReplaySubject<Bool> {get}
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
    
    Alamofire.upload(multipartFormData: { multipartFormData in
        multipartFormData.append(imageJPEG, withName: "file", fileName: "file"+randomString(length: 4)+".jpg", mimeType: "application/octet-stream")
        multipartFormData.append(tokenData!, withName: "token")
        
    },to:uploadURL!, method:.put)
    { (result) in
        switch result {
        case .success(let upload, _, _):
            print("yeeey")
            upload.uploadProgress(closure: { (progressUpload) in
                progress(progressUpload)
            })
            
            upload.responseString{ response in
                let decoder = JSONDecoder()
                let responseJSON = response.data
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
