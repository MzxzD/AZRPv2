//
//  HomeCoordinator.swift
//  Base MVVM Project
//
//  Created by Matija Solić on 04/08/2018.
//  Copyright © 2018 Factory. All rights reserved.
//

import UIKit
//import BaseKit
class HomeCoordinator: Coordinator{
    var childCoordinators: [Coordinator] = []
    var presenter: UINavigationController
    let controller: HomeViewController
    // later remove token because its saved in phones memory
    init (presenter: UINavigationController){
//        presenter.viewControllers.removeAll()
        self.presenter = presenter
        let controller = HomeViewController()
        let homeViewModel = HomeViewModel()
        controller.viewModel = homeViewModel
        self.controller = controller
        self.controller.viewModel.coordinatorDelegate = self
    }
    func start() {
        presenter.pushViewController(controller, animated: true)
    }
    
    
}
extension HomeCoordinator: HomeCoordinatorDelegate {
    func openChatScreen(room: Room) {
        let chatCoordinator = ChatCoordinator(presenter: presenter, room: room)
        addChildCoordinator(childCoordinator: chatCoordinator)
        chatCoordinator.start()
    }
    
    func viewControllerHasFinished() {
        
    }
    
    
}
