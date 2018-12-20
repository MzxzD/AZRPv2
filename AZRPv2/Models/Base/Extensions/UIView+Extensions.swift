//
//  UIView+Extensions.swift
//  UHP zadatak
//
//  Created by Mateo Doslic on 24/10/2018.
//  Copyright © 2018 Mateo Doslic. All rights reserved.
//

import UIKit
extension UIView {
    func addSubviews(_ views: UIView...){
        for view in views{
            self.addSubview(view)
        }
    }
}
