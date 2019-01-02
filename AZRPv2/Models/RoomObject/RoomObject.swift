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

class RoomMessages : Object {
    @objc dynamic var roomID: Int = 0
    var roomObject: RoomObject?
    var messages: [MessageObject] = []
    
    override static func primaryKey() -> String? {
        return "roomID"
    }
    

}


class RoomObject: Object, Codable {
    var type: String = .empty
    var attr: RoomAttr = RoomAttr()
    
    convenience init(type: String, attr: RoomAttr){
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

class RoomAttr: Object, Codable {
    var object: String = .empty
    var name: String = .empty
    var id: Int = 0
    var time: Double = 0
    var sender: String = .empty
    var senderID: Int = 0
    var senderUnique: String = .empty
    var participants: [Int] = []
    
    enum CodingKeys: String, CodingKey {
        case object, name, id, time, sender
        case senderID = "sender_id"
        case senderUnique = "sender_unique"
        case participants
    }
    
    convenience init(object: String, name: String, id: Int, time: Double, sender: String, senderID: Int, senderUnique: String, participants: [Int]){
        self.init()
        self.object = object
        self.name = name
        self.id = id
        self.time = time
        self.sender = sender
        self.senderID = senderID
        self.senderUnique = senderUnique
        self.participants = participants
        
    }
    
    convenience required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let object = try container.decode(String.self, forKey: .object)
        let name = try container.decode(String.self, forKey: .name)
        let id = try container.decode(Int.self, forKey: .id)
        let time = try container.decode(Double.self, forKey: .time)
        let sender = try container.decode(String.self, forKey: .sender)
        let senderID = try container.decode(Int.self, forKey: .senderID)
        let senderUnique = try container.decode(String.self, forKey: .senderUnique)
        let participants = try container.decode([Int].self, forKey: .participants)
        self.init(object: object, name: name, id: id, time: time, sender: sender, senderID: senderID, senderUnique: senderUnique, participants: participants)
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
