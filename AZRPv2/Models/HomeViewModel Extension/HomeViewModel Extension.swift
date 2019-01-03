//
//  HomeViewModel Extension.swift
//  AZRPv2
//
//  Created by Mateo Doslic on 03/01/2019.
//  Copyright © 2019 Mateo Doslic. All rights reserved.
//

import Foundation
import UIKit
import CoreData

extension HomeViewModel {
    
    func SaveNewData(oldRoomMessages: [AZRPRoomMessages], roomMessage: RoomMessages ) -> [AZRPRoomMessages]? {
        var newRoomMessages = oldRoomMessages
        var hasTheRoom: Bool = false
        if newRoomMessages != [] {
            // Look if there's an existing room
            for element in newRoomMessages {
                if let elementID = element.roomObject?.attr?.id {
                    if ( Int(elementID) == (roomMessage.roomObject?.attr.id) ) {
                        hasTheRoom = true
                        element.addToMessages(createNewAZRPMessageObject(azrpRoomMessage: element, messages: roomMessage.messages))
                        
                    }
                }
            }
        }
        if (!hasTheRoom) {
            let newObject = createNewAZRPRoomMessageElement(roomMessage: roomMessage)
            newRoomMessages.append(newObject)
        }
        
        
        return newRoomMessages
    }
    
    func createNewAZRPRoomMessageElement(roomMessage: RoomMessages) -> AZRPRoomMessages {
        let newAZRPRoomMessage = AZRPRoomMessages.init(entity: NSEntityDescription.entity(forEntityName: .AZRPRoomMessages, in: self.managedContext)!, insertInto: self.managedContext)

        if let roomObject = roomMessage.roomObject {
            newAZRPRoomMessage.roomObject = createNewAZRPRoomObjectElement(roomObject: roomObject)
            newAZRPRoomMessage.addToMessages(AZRPMessageObject.init(entity: NSEntityDescription.entity(forEntityName: .AZRPMessageObject, in: self.managedContext)!, insertInto: self.managedContext))
        }
       
        
        return newAZRPRoomMessage
        
    }
    
    func createNewAZRPMessageObject(azrpRoomMessage: AZRPRoomMessages ,messages: [MessageObject]) -> AZRPMessageObject {
        let newMessageObject = AZRPMessageObject.init(entity: NSEntityDescription.entity(forEntityName: .AZRPMessageObject, in: self.managedContext)!, insertInto: self.managedContext)
        if let lastMessage = messages.last {
            newMessageObject.roomMessages = azrpRoomMessage
            newMessageObject.type = lastMessage.type
//            print(newMessageObject.attr)
            newMessageObject.attr?.content = lastMessage.attr.content
            newMessageObject.attr?.messageID = Int64(lastMessage.attr.messageID)
//            newMessageObject.attr?.messageObject = newMessageObject
            newMessageObject.attr?.object = lastMessage.attr.object
            newMessageObject.attr?.room = Int64(lastMessage.attr.room)
            newMessageObject.attr?.roomName = lastMessage.attr.roomName
            newMessageObject.attr?.roomParticipants = lastMessage.attr.roomParticipants
            newMessageObject.attr?.sender = lastMessage.attr.sender
            newMessageObject.attr?.senderID = Int64(lastMessage.attr.senderID)
            newMessageObject.attr?.senderUnique = lastMessage.attr.senderUnique
            newMessageObject.attr?.time = lastMessage.attr.time
            if let location = lastMessage.attr.location {
                // Create Location Object and fill it
            }
            if let file = lastMessage.attr.file {
                // Create File Object and fill it
            }
            return newMessageObject
        }
        return AZRPMessageObject()
    }
    
    func createNewAZRPRoomObjectElement(roomObject: RoomObject) -> AZRPRoomObject {
        let newAZRPRoomObject = AZRPRoomObject.init(entity: NSEntityDescription.entity(forEntityName: .AZRPRoomObject, in: self.managedContext)!, insertInto: self.managedContext)
        newAZRPRoomObject.attr?.name = roomObject.attr.name
        newAZRPRoomObject.attr?.id = Int64(roomObject.attr.id)
        newAZRPRoomObject.attr?.object = roomObject.attr.object
        newAZRPRoomObject.attr?.participants = roomObject.attr.participants
//        newAZRPRoomObject.attr?.roomObject = newAZRPRoomObject
        newAZRPRoomObject.attr?.sender = roomObject.attr.sender
        newAZRPRoomObject.attr?.senderID = Int64(roomObject.attr.senderID)
        newAZRPRoomObject.attr?.senderUnique = roomObject.attr.senderUnique
        newAZRPRoomObject.attr?.time = roomObject.attr.time

        return newAZRPRoomObject
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    func saveNewMessagesOrRooms(roomMessage: RoomMessages, message: MessageObject?) {
        var azrpRoomMessages : [AZRPRoomMessages]!
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: .AZRPRoomMessages)
        
        do {
            azrpRoomMessages = try self.managedContext.fetch(fetchRequest) as? [AZRPRoomMessages]
        } catch let error {
            print(error)
        }
        
//        if roomMessage.roomObject != nil {
//            // Append newRoom
//        } else {
//            // insert new message in existing room
//        }
        //            // Ddodaj u postojeći element
        //            self.roomMessages.append(roomMessage)
        //        }else {
        //            // kreirati novi table item!
        //            for (index, element) in self.roomMessages.enumerated(){
        //
        //                guard let roomAttributeID = element.roomObject?.attr.id else { return }
        //                guard let messageRoom = message?.attr.room else { return }
        //                    if roomAttributeID == messageRoom {
        //                        self.roomMessages[index].messages.append(message!)
        //                    }
        //            }
        //
        //        }
        
        
        
//        print(azrpRoomMessages.first)
        azrpRoomMessages = SaveNewData(oldRoomMessages: azrpRoomMessages, roomMessage: roomMessage)
        

        
  

        
        
//        let newRoomMessage = NSEntityDescription.insertNewObject(forEntityName: .AZRPRoomMessages, into: managedContext) as! AZRPRoomMessages
//
//        let roomObjet = NSEntityDescription.insertNewObject(forEntityName: .AZRPRoomObject, into: managedContext) as! AZRPRoomObject
        
        
//        let newAZRPMessage : [AZRPRoomMessages]

        
    }
    
    
    
    
}
