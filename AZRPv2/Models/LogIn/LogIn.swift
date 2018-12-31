//
//  LogIn.swift
//  AZRPv2
//
//  Created by Mateo Doslic on 20/12/2018.
//  Copyright © 2018 Mateo Doslic. All rights reserved.
//
import Foundation


struct LogIn: Codable {
    let message: String
    let user: User
    let token: String
}

struct User: Codable {
    let name: String
    let id: Int
}


struct ErrorMessage: Codable {
    let detail: String
}
