//
//  NewRoom.swift
//  AZRPv2
//
//  Created by Mateo Doslic on 11/01/2019.
//  Copyright © 2019 Mateo Doslic. All rights reserved.
//

import Foundation

struct NewRoom: Codable {
    var type: String = "create"
    var attr: NewRoomAttr = NewRoomAttr()
}

struct NewRoomAttr: Codable {
    var object: String = "room"
    var senderUnique: String = .empty
    var name: String = .empty
    var participants: [Int] = []
    
    enum CodingKeys: String, CodingKey {
        case object
        case senderUnique = "sender_unique"
        case name, participants
    }
}
