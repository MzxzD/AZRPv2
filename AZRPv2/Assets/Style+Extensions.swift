//
//  Style.swift
//  Base MVVM Project
//
//  Created by Matija Solić on 13/06/2018.
//  Copyright © 2018 Base MVVM Project. All rights reserved.
//

import UIKit
struct Style{
    let textColor: UIColor
    let font: UIFont
}

protocol Stylable: class {
  func  applyStyle(_ style: Style)
}
extension UILabel: Stylable {
    
    func  applyStyle(_ style: Style){
        self.textColor = style.textColor
        self.font = style.font
    }
}
extension UITextView: Stylable {
    
    func  applyStyle(_ style: Style){
        self.textColor = style.textColor
        self.font = style.font
    }
}
extension UITextField: Stylable {
    
    func  applyStyle(_ style: Style){
        self.textColor = style.textColor
        self.font = style.font
    }
}
extension UIButton: Stylable {
    
    func  applyStyle(_ style: Style){
        self.setTitleColor(style.textColor, for: .normal)
        self.titleLabel?.font = style.font
    }
}
