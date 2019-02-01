//
//  HomeCoordinatorDelegate.swift
//  AZRPv2
//
//  Created by Mateo Doslic on 31/12/2018.
//  Copyright © 2018 Mateo Doslic. All rights reserved.
//

import Foundation

protocol HomeCoordinatorDelegate: CoordinatorDelegate {
    func openChatScreen(roomID: Int)
    func presentNewRoomScreen()
}
