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
            self.socketController.socket.write(string: messageToSend)
        }else {
            // error no input
        }
    }
    
}

extension ChatViewModel {
    
    private func validateInputData(message: String?, image: UIImage?, coordinates: Coordinates?) -> Bool{
        if (message == nil && image == nil && coordinates == nil){
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
            // make upload and then add the id number to it
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

protocol ChatViewModelProtocol: CollectionViewCellDelegate, WebSocketDelegate {
    var room: Room {get}
    func openImagePicker(imagePicker: UIImagePickerController)
    var coordinatorDelegate: ChatCoordinatorDelegate? {get set}
}

public protocol CollectionViewCellDelegate: class {
    func sortChatBubbles(messagePosition: Int) -> Bool
}

public protocol KeyBoardViewDelegate: class {
    func sendMessage()
    
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
