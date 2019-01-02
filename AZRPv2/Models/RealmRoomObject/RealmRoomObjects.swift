//
//  RealmRoomObjects.swift
//  AZRPv2
//
//  Created by Mateo Doslic on 02/01/2019.
//  Copyright © 2019 Mateo Doslic. All rights reserved.
//
//
//import Foundation
//import RealmSwift
//import Realm

//class RoomMessages: Object  {
//    var roomObject: RealmRoomObject?
//    var messages: [MessageObject] = []
//
//    override static func primaryKey() -> String? {
//        return "roomID"
//    }
//
//}
//
//class RealmRoomObject: Object {
//    var type: String?
//    var attr: RealmRoomAttr?
//}
//
//class RealmRoomAttr: Object {
//    var object, name: String?
//    var id: Int?
//    var time: Double?
//    var sender: String?
//    var senderID: Int?
//    var senderUnique: String?
//    var participants: [Int] = []
//}
//
//class RealmMessageObject: Object {
//    var type: String?
//    var attr: RealmAttributes?
//
//}
//
//class RealmAttributes: Object {
//    var object: String?
//    var content: String?
//    var messageID: Int?
//    var time: Double?
//    var sender: String?
//    var senderID: Int?
//    var senderUnique: String?
//    var roomParticipants: [Int] = []
//    var room: Int?
//    var roomName: String?
//    var location, file: JSONNull?
//}
