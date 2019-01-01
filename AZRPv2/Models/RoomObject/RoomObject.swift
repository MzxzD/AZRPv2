//
//  RoomObject.swift
//  AZRPv2
//
//  Created by Mateo Doslic on 01/01/2019.
//  Copyright © 2019 Mateo Doslic. All rights reserved.
//

import Foundation


struct RoomMessages {
    var roomObject: RoomObject?
    var messages: [MessageObject]

}

struct RoomObject: Codable {
    let type: String
    let attr: RoomAttr
}

struct RoomAttr: Codable {
    let object, name: String
    let id: Int
    let time: Double
    let sender: String
    let senderID: Int
    let senderUnique: String
    let participants: [Int]
    
    enum CodingKeys: String, CodingKey {
        case object, name, id, time, sender
        case senderID = "sender_id"
        case senderUnique = "sender_unique"
        case participants
    }
}
