//
//  WebSocket.swift
//  AZRPv2
//
//  Created by Mateo Doslic on 02/01/2019.
//  Copyright © 2019 Mateo Doslic. All rights reserved.
//

import Foundation
import SocketIO
import Starscream
import CoreData
import Realm
import RealmSwift
import RxSwift

class WebSocketController: WebSocketDelegate {
    
    var socket: WebSocket!
    let realmServise : RealmSerivce
    let lastRoomIDAndlastMessageID: (roomID: Int?, messageID: Int?)
    var error: PublishSubject<String>
    var newRoom: ReplaySubject<Bool>
    var newMessage: ReplaySubject<Bool>

    
    private init() {
        self.realmServise = RealmSerivce()
        self.error = PublishSubject<String>()
        self.newRoom = ReplaySubject<Bool>.create(bufferSize: 1)
        self.newMessage = ReplaySubject<Bool>.create(bufferSize: 1)
        self.lastRoomIDAndlastMessageID = self.realmServise.getLastRoomAndMessageId()

    }
    
    static let shared: WebSocketController = WebSocketController()
    
    
    func startWebSocket(){
        self.socket = self.createWebSocket()
        self.socket.delegate = self
        self.socket.connect()
    }
    
    func sendMessage(message: String) {
        self.socket.write(string: message)
    }
    
    private func createWebSocket() -> WebSocket {
        return WebSocket(url: URL(string: self.getWebSocketURL())!)
    }
    
    private func getWebSocketURL() -> String{
        return  (WebSocketAdress().adress + getTokenFromData()+"/"+String(-1)+"/"+String(self.lastRoomIDAndlastMessageID.messageID ?? -1)+"/")
    }
    
    
    func websocketDidConnect(socket: WebSocketClient) {
        print("websocket is connected")
    }
    
    func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
        print("websocket is disconnected: \(String(describing: error?.localizedDescription))")
        print("trying to recoonect")
        self.socket.connect()
        
    }
    
    func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
        let responseData = text.data(using: String.Encoding.utf8)
        print(text)
        saveRecivedMessageOrRoom(data: responseData)
    }
    
    func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
        print("got some data: \(data.count)")
        
    }
    
    private func saveRecivedMessageOrRoom(data: Data?) {
        let messageRoomTuple: (message: MessageObject?, room:RoomObject?) = serialize(data: data!)
        switch messageRoomTuple {
        case (nil, nil):
            print("No new item for you")
        default:
            // NEW ROOM HAS BEEN ADDED
            if messageRoomTuple.message == nil {
                updateRoomObject(websocketRoom: messageRoomTuple.room!)
                self.newRoom.onNext(true)
            }else {
                // NEW MESSAGE IN EXISTING ROOM
                updateMessages(websocketMessage: messageRoomTuple.message!)
                self.newMessage.onNext(true)
                
            }
        }
    }
    
    func serialize(data: Data) -> (MessageObject?, RoomObject?) {
        let jsonDecoder = JSONDecoder()
        var message: MessageObject? = nil
        var room: RoomObject? = nil
        let userID = getUserIDFromData()
        
        do{
            let data = try jsonDecoder.decode(MessageObject.self, from: data)
            //            guard let messageData = newMessage.attr.content else { return }
            message = data
            //            print(data)
        } catch {
            
            do {
                let data = try jsonDecoder.decode(RoomObject.self, from: data)
                room = data
                //                print(data)
            } catch let error {
                self.error.onNext(error.localizedDescription)
            }
            
        }
        
        var messageToReturn: MessageObject?
        
        if let filteredMessage = message {
            for id in filteredMessage.attr.roomParticipants{
                if userID == id {
                    messageToReturn = message
                }
            }
        }
        
        var roomToReturn : RoomObject?
        if let filteredRoom = room {
            for id in filteredRoom.attr.participants {
                if userID == id {
                    roomToReturn = room
                }
            }
        }
        
        if messageToReturn?.type == "response" {
            messageToReturn = nil
        }
        
        if roomToReturn?.type ==  "response" {
            roomToReturn = nil
        }
        
        return (messageToReturn, roomToReturn)
        
    }
    
    
    func updateRoomObject(websocketRoom: RoomObject) {
        var realmRoom : [Room] = []
        for room in self.realmServise.realm.objects(Room.self) {
            realmRoom += [room]
        }
        let newRoom: Room = Room()
        newRoom.id = websocketRoom.attr.id
        newRoom.messages = List<Messages>()
        newRoom.name = websocketRoom.attr.name
        newRoom.object = websocketRoom.attr.object
        newRoom.sender = websocketRoom.attr.sender
        newRoom.time = websocketRoom.attr.time
        
        realmRoom += [newRoom]
        
        if (!self.realmServise.update(object: newRoom)){
            self.error.onNext("Error saving new Room")
        }
        
    }
    
    func updateMessages (websocketMessage: MessageObject){
        //        var message: MessageObject!
        var newRoom = Room()
        for (_, element) in self.realmServise.realm.objects(Room.self).enumerated()  {
            if element.id == websocketMessage.attr.room {
                self.realmServise.realm.beginWrite()
                newRoom.messages = element.messages
                newRoom.messages.append(storeWSdataToRealmMessages(wsMessage: websocketMessage))
                element.messages = newRoom.messages
                
              
            }
        }
        do {
            try self.realmServise.realm.commitWrite()
        }catch let error {
            self.error.onNext(error.localizedDescription)
        }
        
    }
    
    func storeWSdataToRealmMessages(wsMessage: MessageObject) -> Messages{
        let message: Messages = Messages()
        
        message.content = wsMessage.attr.content
        message.messageID = wsMessage.attr.messageID
        message.object = wsMessage.attr.object
        message.room = wsMessage.attr.room
        message.roomName = wsMessage.attr.roomName
        message.sender = wsMessage.attr.sender
        message.senderID = wsMessage.attr.senderID
        message.time = wsMessage.attr.time
        
        if let location = wsMessage.attr.location {
            message.location?.latitude = location.latitude
            message.location?.longitude = location.longitude
        }
        
        if let file = wsMessage.attr.file {
            message.file?.fileHashValue = file.hash
            message.file?.name = file.name
            message.file?.url = file.url
        }
        
        return message
    }

}




public func getTokenFromData() -> String {
    var user: NSManagedObject!
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return .empty }
    let managedContext = appDelegate.persistentContainer.viewContext
    let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "AZRPUser")
    do {
        user = try managedContext.fetch(fetchRequest).first
    } catch let error as NSError {
        print("Error occured while fetching items", error)
    }
    
    return user.value(forKey: "token") as? String ?? .empty
    
}
