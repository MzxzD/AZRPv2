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

struct MessageObject: Codable {
    let type: String
    let attr: Attributes
}

struct Attributes: Codable {
    let object: String
    let content: String
    let messageID: Int
    let time: Double
    let sender: String
    let senderID: Int
    let senderUnique: String
    let roomParticipants: [Int]
    let room: Int
    let roomName: String
    let location, file: JSONNull?
    
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
