//
//  WelcomeViewModel.swift
//  AZRPv2
//
//  Created by Mateo Doslic on 31/12/2018.
//  Copyright © 2018 Mateo Doslic. All rights reserved.
//

import Foundation

class WelcomeViewModel {
    
    var coordinatorDelegate: LoginCoordinatorDelegate?
    
    
    func openHomeScreen() {
        coordinatorDelegate?.openHomeScreen(token: "string")
    }
    
}
