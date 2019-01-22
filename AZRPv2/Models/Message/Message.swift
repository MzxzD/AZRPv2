//
//  Message.swift
//  AZRPv2
//
//  Created by Mateo Doslic on 31/12/2018.
//  Copyright © 2018 Mateo Doslic. All rights reserved.
//
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? newJSONDecoder().decode(Welcome.self, from: jsonData)

import Foundation
import Realm
import RealmSwift

//struct MessageObject: Codable {
//    var type: String
//    var attr: Attributes
//    
//}
//
//struct Attributes: Codable {
//    let object: String
//    let content: String
//    let messageID: Int
//    let time: Double
//    let sender: String
//    let senderID: Int
//    let senderUnique: String
//    let roomParticipants: [Int]
//    let room: Int
//    let roomName: String
//    let location: MessageLocation?
//    let file: File?
//    
//    
//    enum CodingKeys: String, CodingKey {
//        case object, content,file
//        case messageID = "message_id"
//        case time, sender
//        case senderID = "sender_id"
//        case senderUnique = "sender_unique"
//        case roomParticipants = "room_participants"
//        case room
//        case roomName = "room_name"
//        case location
//    }
//}
//
//struct File: Codable {
//    let name, hash: String
//    let url: String
//}
//
//struct MessageLocation: Codable {
//    let latitude, longitude: Double
//}
//
//











struct MessageObject: Codable {
    let type: String
    let attr: Attributes
}

struct Attributes: Codable {
    let object, content: String
    let messageID: Int
    let time: Double
    let sender: String
    let senderID: Int
    let senderUnique: String
    let roomParticipants: [Int]
    let room: Int
    let roomName: String
    let location: MessageLocation?
    let file: File?
    
    enum CodingKeys: String, CodingKey {
        case object, content
        case messageID = "message_id"
        case time, sender
        case senderID = "sender_id"
        case senderUnique = "sender_unique"
        case roomParticipants = "room_participants"
        case room
        case roomName = "room_name"
        case location, file
    }
}

struct File: Codable {
    let hash, name: String
}

struct MessageLocation: Codable {
    let latitude, longitude: Double
}
