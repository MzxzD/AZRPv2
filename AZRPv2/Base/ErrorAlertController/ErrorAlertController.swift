//
//  ErrorAlert.swift
//  ePetrokemija
//
//  Created by Work on 27/08/2018.
//  Copyright © 2018 Factory. All rights reserved.
//

import Foundation
import UIKit

class ErrorAlertController {
    func alert(viewToPresent: UIViewController, title: String, message: String) -> Void
    {
        let attributedText =  NSMutableAttributedString().characterSubscriptAndSuperscript(
            string: message,
            characters: ["2","3","5","6","7","8"],
            type: .aSub,
            fontSize: 17,
            scriptFontSize: 13,
            offSet: 4,
            alignment: .center)
        let action = UIAlertAction(title: "OK", style: .default)
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.view.tintColor = .blue
        alert.setValue(attributedText, forKey: "attributedMessage")
        
        
        alert.addAction(action)
        viewToPresent.present(alert, animated: true, completion: nil)
    }
}
