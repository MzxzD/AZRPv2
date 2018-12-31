//
//  LoginCoordinatorDelegate.swift
//  AZRPv2
//
//  Created by Mateo Doslic on 31/12/2018.
//  Copyright © 2018 Mateo Doslic. All rights reserved.
//

import Foundation
protocol LoginCoordinatorDelegate: CoordinatorDelegate {
    func openHomeScreen(token: String)
}
