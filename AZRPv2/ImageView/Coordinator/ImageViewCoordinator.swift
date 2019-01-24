//
//  ImageViewCoordinator.swift
//  AZRPv2
//
//  Created by Mateo Doslic on 18/01/2019.
//  Copyright © 2019 Mateo Doslic. All rights reserved.
//

import Foundation
import UIKit
//import BaseKit
class ImageViewCoordinator: Coordinator{
    var childCoordinators: [Coordinator] = []
    var presenter: UINavigationController
    let controller: ImageViewController
    init (urlToImage: String, imageName: String, presenter: UINavigationController){
        self.presenter = presenter
        let controller = ImageViewController()
        controller.title = imageName
        let viewModel = ImageViewModel(urlToImage: urlToImage)
        controller.viewModel = viewModel
        controller.title = imageName
        self.controller = controller
     
    }
    func start() {
        presenter.pushViewController(controller, animated: true)
    }
    
    
}

