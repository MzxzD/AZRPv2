//
//  ErrorAlert.swift
//  UHP zadatak
//
//  Created by Mateo Doslic on 24/10/2018.
//  Copyright © 2018 Mateo Doslic. All rights reserved.
//
import Foundation
import UIKit

class ErrorAlert {
    func alert(viewToPresent: UIViewController, title: String, message: String) -> Void
    {
        let action = UIAlertAction(title: "OK", style: .default)
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(action)
        viewToPresent.present(alert, animated: true, completion: nil)
    }
}
