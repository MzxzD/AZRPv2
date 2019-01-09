//
//  ChatCoordinator.swift
//  AZRPv2
//
//  Created by Mateo Doslic on 05/01/2019.
//  Copyright © 2019 Mateo Doslic. All rights reserved.
//

import Foundation
import UIKit
//import BaseKit
class ChatCoordinator: Coordinator{
    var childCoordinators: [Coordinator] = []
    var presenter: UINavigationController
    let controller: ChatCollectionViewController
    // later remove token because its saved in phones memory
    init (presenter: UINavigationController, room: Room){
        //        presenter.viewControllers.removeAll()
        self.presenter = presenter
        let controller = ChatCollectionViewController(collectionViewLayout: UICollectionViewFlowLayout())
        let homeViewModel = ChatViewModel(room: room)
        controller.viewModel = homeViewModel
        self.controller = controller
    }
    func start() {
        presenter.pushViewController(controller, animated: true)
    }
    
    
}
