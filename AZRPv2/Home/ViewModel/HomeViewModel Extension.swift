//
//  HomeViewModel Extension.swift
//  AZRPv2
//
//  Created by Mateo Doslic on 05/01/2019.
//  Copyright © 2019 Mateo Doslic. All rights reserved.
//

import Foundation
import Realm
import RealmSwift
import RxSwift

extension HomeViewModel {
    
    
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
        
        return (messageToReturn, roomToReturn)
        
    }
    
    
    func saveRecivedMessageOrRoom(data: Data?) {
        
        
        let messageRoomTuple: (message: MessageObject?, room:RoomObject?) = serialize(data: data!)
        switch messageRoomTuple {
        case (nil, nil):
            print("No new item for you")
        default:
            // NEW ROOM HAS BEEN ADDED
            if messageRoomTuple.message == nil {
                updateRoomObject(websocketRoom: messageRoomTuple.room!)
                self.refreshPublisher.onNext(true)
            }else {
                // NEW MESSAGE IN EXISTING ROOM
                updateMessages(websocketMessage: messageRoomTuple.message!)
                self.refreshPublisher.onNext(true)
                
            }
        }
    }
    
    func updateRoomObject(websocketRoom: RoomObject) {
        var realmRoom : [Room] = []
        realmRoom = self.realmRooms
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
        var newRoom : Room!
        for (_, element) in self.realmRooms.enumerated() {
            if element.id == websocketMessage.attr.room {
                self.realmServise.realm.beginWrite()
                newRoom = element
                newRoom.messages.append(storeWSdataToRealmMessages(wsMessage: websocketMessage))
                
                do {
                   try self.realmServise.realm.commitWrite()
                }catch let error {
                    self.error.onNext(error.localizedDescription)
                }
                
                
            }
        }
        if (!self.realmServise.update(object: newRoom!)) {
            self.error.onNext("BOOOO!")
        }
        
        
        
        
        //                for (index, element) in self.roomMessages.enumerated(){
        //                    if element.roomObject?.attr.id == message.attr.room {
        //                        let realmID = element.roomID
        //                        self.roomMessages[index].messages += [message]
        //                        newRoom = self.roomMessages
        //                        let lol = self.realmServise.realm.object(ofType: RoomMessages.self, forPrimaryKey: realmID)
        //                        if (!self.realmServise.deleteMessageObject(object: (lol?.messages.first)!)) {
        //                            self.error.onNext("YOU FAILURE")
        //                        }
        //                        if (!self.realmServise.update(object: lol!)) {
        //                            self.error.onNext("BOOOO!")
        //                        }
        //                        self.refreshPublisher.onNext(true)
        //
        //                    }
        //                }
        //                for element in newRoom{
        //                    if(!self.realmServise.create(object: element)){
        //                        self.error.onNext("ErrorSaving new message")
        //                    }
        //                }
        
        
        
    }
    
 
    
}
