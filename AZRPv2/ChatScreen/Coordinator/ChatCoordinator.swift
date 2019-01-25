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
    init (roomID: Int, presenter: UINavigationController){
        self.presenter = presenter
        let controller = ChatCollectionViewController(collectionViewLayout: UICollectionViewFlowLayout())
        let homeViewModel = ChatViewModel(roomID: roomID)
        controller.viewModel = homeViewModel
        self.controller = controller
        self.controller.viewModel.coordinatorDelegate = self
    }
    func start() {
        presenter.pushViewController(controller, animated: true)
    }
    

}

extension ChatCoordinator: ChatCoordinatorDelegate{
    func openImageView(url: String, name: String) {
        let imageCoordinator = ImageViewCoordinator(urlToImage: url, imageName: name, presenter: presenter)
        addChildCoordinator(childCoordinator: imageCoordinator)
        imageCoordinator.start()
    }
    
   
    
    func openNavigationView(coordinates: Coordinates, userName: String) {
        let navigationView = LocationViewCoordinator(coordinates: coordinates, userName: userName, presenter: presenter)
        addChildCoordinator(childCoordinator: navigationView)
        navigationView.start()
    }
    
    func presentImagePicker(imagePicker: UIImagePickerController) {
        self.presenter.present(imagePicker, animated: true, completion: nil)
    }
    
    
}
