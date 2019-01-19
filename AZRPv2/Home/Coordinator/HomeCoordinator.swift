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
    let delegate = UIApplication.shared.delegate as! AppDelegate
    var childCoordinators: [Coordinator] = []
    var presenter: UINavigationController
    let controller: HomeViewController
    // later remove token because its saved in phones memory
    init (presenter: UINavigationController){
        delegate.socketController.startWebSocket()
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
    func presentNewRoomScreen() {
        let newRoomController = NewRoomViewController()
        let VM = NewRoomViewModel()
        newRoomController.viewModel = VM
        newRoomController.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        presenter.present(newRoomController, animated: true)
    }
    
    func openChatScreen(roomID: Int) {
        let chatCoordinator = ChatCoordinator(roomID: roomID, presenter: presenter)
        addChildCoordinator(childCoordinator: chatCoordinator)
        chatCoordinator.start()
    }
    
    
    func viewControllerHasFinished() {
        
    }
    
    
}
