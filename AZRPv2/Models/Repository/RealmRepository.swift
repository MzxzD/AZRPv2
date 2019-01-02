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
    
    func deleteRoomObject<T: RoomMessages>(object: T) -> Bool{
        do {
            try realm.write {
                realm.delete(realm.objects(RoomMessages.self).filter("roomObject=%@", object.roomObject!))
            }
            
        } catch {
            return false
        }
        return true
    }
    
    func deleteMessageObject<T: MessageObject>(object: T) -> Bool{
        do {
            try realm.write {
                realm.delete(realm.objects(MessageObject.self).filter("room=%@", object.attr.room))
            }
            
        } catch {
            return false
        }
        return true
    }
    
    func getRooms() -> (Observable<[RoomMessages]>){
        var rooms: [RoomMessages] = []
        let realmRooms = self.realm.objects(RoomMessages.self)
        for room in realmRooms {
            rooms += [room]
        }
        return Observable.just(rooms)
    }
    
}

