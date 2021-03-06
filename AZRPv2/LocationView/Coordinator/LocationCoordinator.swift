//
//  LocationCoordinator.swift
//  AZRPv2
//
//  Created by Mateo Doslic on 18/01/2019.
//  Copyright © 2019 Mateo Doslic. All rights reserved.
//

import Foundation
import UIKit
class LocationViewCoordinator: Coordinator{
    var childCoordinators: [Coordinator] = []
    var presenter: UINavigationController
    let controller: LocationViewController
    init (coordinates: Coordinates, userName: String, presenter: UINavigationController){
        self.presenter = presenter
        let controller = LocationViewController()
        let viewModel = LocationViewModel(longitude: coordinates.longitude, latitude: coordinates.latitude, userName: userName)
        controller.viewModel = viewModel
        self.controller = controller
        
    }
    func start() {
        presenter.pushViewController(controller, animated: true)
    }
    
    
}
