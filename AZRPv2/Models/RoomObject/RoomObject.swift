//
//  RoomObject.swift
//  AZRPv2
//
//  Created by Mateo Doslic on 01/01/2019.
//  Copyright © 2019 Mateo Doslic. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

struct RoomMessages {
//    @objc dynamic var roomID: Int = 0
    var roomObject: RoomObject
    var messages: [MessageObject]
    
//    override static func primaryKey() -> String? {
//        return "roomID"
//    }
    

}


struct RoomObject: Codable {
    var type: String
    var attr: RoomAttr
    
  
    
}

struct RoomAttr: Codable {
    var object: String
    var name: String
    var id: Int
    var time: Double
    var sender: String
    var senderID: Int
    var senderUnique: String
    var participants: [Int]
    
    enum CodingKeys: String, CodingKey {
        case object, name, id, time, sender
        case senderID = "sender_id"
        case senderUnique = "sender_unique"
        case participants
    }
    
}



struct RoomParsed: Codable {
    let type: String
    let attr: ParsedAttr
}

struct ParsedAttr: Codable {
    let object, name: String
    let id: Int
    let time: Double
}
