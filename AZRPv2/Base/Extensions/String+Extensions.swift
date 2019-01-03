//
//  String+Extensions.swift
//  UHP zadatak
//
//  Created by Mateo Doslic on 24/10/2018.
//  Copyright © 2018 Mateo Doslic. All rights reserved.
//

import Foundation
extension String {
    static let empty = ""
    static let AZRPRoomMessages = "AZRPRoomMessages"
    static let AZRPRoomObject = "AZRPRoomObject"
    static let AZRPUser = "AZRPUser"
    static let AZRPRoomAttr = "AZRPRoomAttr"
    static let AZRPMessageObject = "AZRPMessageObject"
    static let AZRPMessageLocation = "AZRPMessageLocation"
    static let AZRPFile = "AZRPFile"
    static let AZRPAttributes = "AZRPAttributes"
    
}

public func randomString(length: Int) -> String {
    let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    return String((0...length-1).map{ _ in letters.randomElement()! })
}
