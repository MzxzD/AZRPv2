//
//  RealmRoomObjects.swift
//  AZRPv2
//
//  Created by Mateo Doslic on 02/01/2019.
//  Copyright © 2019 Mateo Doslic. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

class Room: Object  {
    @objc dynamic var object: String?
    @objc dynamic var  name: String?
    @objc dynamic var  id: Int = -1
    @objc dynamic var  time: Double = 0
    @objc dynamic var  sender: String?
    var messages: List<Messages> = List<Messages>()

    override class func primaryKey() -> String? {
        return "id"
    }
    }



class Messages: Object {
    @objc dynamic var object: String?
    @objc dynamic var content: String?
    @objc dynamic var messageID: Int = -1
    @objc dynamic var time: Double = 0
    @objc dynamic var sender: String?
    @objc dynamic var senderID: Int = -1
    @objc dynamic var room: Int = -1
    @objc dynamic var roomName: String?
    @objc dynamic var fileHashValue: String?
    @objc dynamic var fileName: String?
    @objc dynamic var latitude: Double = 0
    @objc dynamic var longitude: Double = 0
    
//    var file: UserFile?
//    var location: UserLocation?
    
    override class func primaryKey() -> String? {
        return "messageID"
    }
}

//class UserFile: Object {
//    
//    @objc dynamic var name, fileHashValue: String?
//    @objc dynamic var url: String?
//    
//}
//
//class UserLocation: Object {
//    @objc dynamic var latitude: Double = 0
//    @objc dynamic var longitude: Double = 0
//}
