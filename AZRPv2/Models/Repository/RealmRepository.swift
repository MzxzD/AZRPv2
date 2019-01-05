//
//  RealmRepository.swift
//  OrtoClass
//
//  Created by Mateo Doslic on 10/09/2018.
//  Copyright © 2018 Mateo Doslic. All rights reserved.
//

import Foundation
import Realm
import RealmSwift
import RxSwift

class RealmSerivce {
    var realm = try! Realm()
    let errorOccured = PublishSubject<Bool>()
    
    
    func create<T: Object >(object: T) -> Bool {
    
        do{
            try realm.write {
                realm.add(object)
            }
        }catch {
            return false
        }
        return true
    }
    
    func update<T: Object>(object: T) -> Bool{
        do {
            try realm.write {
                realm.add(object, update: true)
            }
            
        }catch {
            return false
        }
        return true
    }
    
    func deleteRoomObject<T: Room>(object: T) -> Bool{
        do {
            try realm.write {
                realm.delete(realm.objects(Room.self).filter("id=%@", object.id))
            }
            
        } catch {
            return false
        }
        return true
    }
    
    func deleteMessageObject<T: Messages>(object: T) -> Bool{
        do {
            try realm.write {
                realm.delete(realm.objects(Messages.self).filter("messageID=%@", object.messageID))
            }
            
        } catch {
            return false
        }
        return true
    }
    
    func getRooms() -> (Observable<[Room]>){
        var rooms: [Room] = []
        let realmRooms = self.realm.objects(Room.self)
        for room in realmRooms {
            rooms += [room]
        }
        return Observable.just(rooms)
    }
    
    func getLastRoomID() -> Int? {
        let realmRooms = self.realm.objects(Room.self)
        if let lastRoomID = realmRooms.last?.id {
            return lastRoomID
        }
        return nil
    }
    
    func getLastMessageID() -> Int? {
        let realmRooms = self.realm.objects(Room.self)
        var lastMessageID : Int = -1
//        if let lastMessageID = realmRooms.last?.messages.last?.messageID{
//            return lastMessageID
//        }
        for room in realmRooms {
            for message in room.messages {
                if lastMessageID > -1 {
                        if message.messageID > lastMessageID {
                            lastMessageID = message.messageID
                    }
                }else {
                        lastMessageID = message.messageID
                }
            }
        }
        
        if lastMessageID != -1 {
            return lastMessageID
        }else {
            return nil
        }
        
    }
    
    func getLastRoomAndMessageId() -> (roomID: Int?, messageID: Int?){
        
        let realmRooms = self.realm.objects(Room.self)
        var roomID: Int = -1
        var messageID : Int = -1
        var messageTime: Double = 0
        
        for room in realmRooms {
            for message in room.messages {
                if message.time > messageTime {
                    messageTime = message.time
                    messageID = message.messageID
                    roomID = room.id
                }
            }
        }

        if roomID == -1 || messageID == -1 {
            return (nil, nil)
        } else {
            return (roomID, messageID)
        }
        
        
    }
    
}

