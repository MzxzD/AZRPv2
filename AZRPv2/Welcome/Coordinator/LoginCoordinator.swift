//
//  LoginCoordinator.swift
//  AZRPv2
//
//  Created by Mateo Doslic on 30/12/2018.
//  Copyright © 2018 Mateo Doslic. All rights reserved.
//
import UIKit
//import BaseKit
class LoginCoordinator: Coordinator{
    var childCoordinators: [Coordinator] = []
    var presenter: UINavigationController
    let controller: WelcomeViewController
    init (presenter: UINavigationController){
        self.presenter = presenter
        let controller = WelcomeViewController()
        //Add ViewModel initialization.
//        let homeViewModel = LoginViewModel()
//        controller.loginView.loginViewModel = homeViewModel
        self.controller = controller
    }
    func start() {
        presenter.pushViewController(controller, animated: true)
    }
    
    
}
