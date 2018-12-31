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
        let welcomeViewModel = WelcomeViewModel()
        controller.welcomeViewModel = welcomeViewModel
        self.controller = controller
        self.controller.welcomeViewModel.coordinatorDelegate = self

    }
    func start() {
        presenter.pushViewController(controller, animated: true)
    }
    
    
}
extension LoginCoordinator: LoginCoordinatorDelegate {
    func openHomeScreen(token: String) {
        let homeCoordinator = HomeCoordinator(presenter: presenter)
        homeCoordinator.start()
        addChildCoordinator(childCoordinator: homeCoordinator)
    }
    
    func viewControllerHasFinished() {
        
    }
    
    
}
