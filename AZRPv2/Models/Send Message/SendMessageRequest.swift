//
//  SendMessageRequest.swift
//  AZRPv2
//
//  Created by Mateo Doslic on 21/12/2018.
//  Copyright © 2018 Mateo Doslic. All rights reserved.
//

import Foundation

enum SendMessageType : String {
    case create = "create"
}


enum ObjectType : String {
    case message = "message"
    case room = "room"
}

struct SendMessageRequest: Codable {
    var type: String
    var attr: Attr
    
    init() {
        self.type = .empty
        self.attr = Attr()
    }
}

struct Attr: Codable {
    var object, senderUnique, content: String
    var file: Int?
    var room: Int
    var location: Location?
    
    init() {
        object = .empty
        senderUnique = .empty
        content = .empty
        room = 0
    }
    
    enum CodingKeys: String, CodingKey {
        case object
        case senderUnique = "sender_unique"
        case content, file, room, location
    }
}

struct Location: Codable {
    let latitude, longitude: Double
}
