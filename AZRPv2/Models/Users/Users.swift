//
//  Users.swift
//  AZRPv2
//
//  Created by Mateo Doslic on 21/12/2018.
//  Copyright © 2018 Mateo Doslic. All rights reserved.
//


import Foundation

typealias Users = [UserEntry]

struct UserEntry: Codable {
    let id: Int
    let username: String
}
