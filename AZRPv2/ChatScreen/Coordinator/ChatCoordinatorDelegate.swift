//
//  ChatCoordinatorDelegate.swift
//  AZRPv2
//
//  Created by Mateo Doslic on 09/01/2019.
//  Copyright © 2019 Mateo Doslic. All rights reserved.
//

import Foundation
import UIKit

protocol ChatCoordinatorDelegate: class {
    func presentImagePicker(imagePicker: UIImagePickerController)
    func openImageView(url: String, name: String)
    func openNavigationView(longitude: Double, latitude: Double)
}
