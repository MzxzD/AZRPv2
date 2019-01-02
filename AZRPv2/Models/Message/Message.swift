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

class MessageObject: Object, Codable {
    var type: String = .empty
    var attr: Attributes = Attributes()
    
    
    convenience init(type: String, attr: Attributes){
        self.init()
        self.type = type
        self.attr = attr
    }
    
    required init() {
        super.init()
    }
    
    required init(realm: RLMRealm, schema: RLMObjectSchema) {
        super.init(realm: realm, schema: schema)
    }
    
    required init(value: Any, schema: RLMSchema) {
        super.init(value: value, schema: schema)
    }
    
}

class Attributes: Object, Codable {
    var object: String = .empty
    var content: String = .empty
    var messageID: Int = 0
    var time: Double = 0
    var sender: String = .empty
    var senderID: Int = 0
    var senderUnique: String = .empty
    var roomParticipants: [Int] = []
    var room: Int = 0
    var roomName: String = .empty
    var location, file: JSONNull?
    
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
    
    convenience init(object: String, content: String, messageID: Int, time: Double, sender: String, senderID: Int, senderUnique: String, roomParticipants: [Int], room: Int, roomName: String, location: JSONNull?, file: JSONNull?){
        self.init()
        self.object = object
        self.content = content
        self.messageID = messageID
        self.time = time
        self.sender = sender
        self.senderID = senderID
        self.senderUnique = senderUnique
        self.roomParticipants = roomParticipants
        self.room = room
        self.roomName = roomName
        self.location = location ?? nil
        self.file = file ?? nil
    }
    
    convenience required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let object = try container.decode(String.self, forKey: .object)
        let content = try container.decode(String.self, forKey: .content)
        let messageID = try container.decode(Int.self, forKey: .messageID)
        let time = try container.decode(Double.self, forKey: .time)
        let sender = try container.decode(String.self, forKey: .sender)
        let senderID = try container.decode(Int.self, forKey: .senderID)
        let senderUnique = try container.decode(String.self, forKey: .senderUnique)
        let roomParticipants = try container.decode([Int].self, forKey: .roomParticipants)
        let room = try container.decode(Int.self, forKey: .room)
        let roomName = try container.decode(String.self, forKey: .roomName)
        let location = try container.decode(JSONNull.self, forKey: .location)
        let file = try container.decode(JSONNull.self, forKey: .file)

        self.init(object: object, content: content, messageID: messageID, time: time, sender: sender, senderID: senderID, senderUnique: senderUnique, roomParticipants: roomParticipants, room: room, roomName: roomName, location: location, file: file)

    }
    
    
    required init() {
        super.init()
    }
    
    required init(realm: RLMRealm, schema: RLMObjectSchema) {
        super.init(realm: realm, schema: schema)
    }
    
    required init(value: Any, schema: RLMSchema) {
        super.init(value: value, schema: schema)
    }
    
    
    
}

// MARK: Encode/decode helpers

class JSONNull: Codable, Hashable {
    
    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }
    
    public var hashValue: Int {
        return 0
    }
    
    public init() {}
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}
