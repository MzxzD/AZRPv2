//
//  KeyboardView.swift
//  AZRPv2
//
//  Created by Mateo Doslic on 09/01/2019.
//  Copyright © 2019 Mateo Doslic. All rights reserved.
//

import Foundation
import UIKit


class KeyboardView : UIView {
    

    weak var imageDelegate: ImageDelegate?
    weak var locationDelegate: LocationDelegate?
    
    let inputTextFiled : UITextField = {
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    let sendButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(#imageLiteral(resourceName: "SendIcon"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(sendMessage), for: .touchUpInside)
        return button
    }()
    
    let gpsButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let image = #imageLiteral(resourceName: "GpsImage")
        button.setImage(image, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(addLocation), for: .touchUpInside)
        return button
    }()
    
    let imageButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let image = #imageLiteral(resourceName: "ImageIcon")
        button.setImage(image, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(addImage), for: .touchUpInside)
        return button
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.lightGray
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @objc func sendMessage() {
        print("sending")
    }
    
    @objc func addImage() {
        print("adding image")
        self.imageDelegate?.getImage()
   
    }
    
    @objc func addLocation() {
        print("adding location")
        self.locationDelegate?.getLocation()
    }
    
    private func setupView() {
        self.addSubviews(inputTextFiled, sendButton, gpsButton,imageButton )
        setupConstraints()
    }
    
    
    private func setupConstraints() {
            let constraints = [
                
                imageButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
                imageButton.topAnchor.constraint(equalTo: topAnchor, constant: 2),
                imageButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -2),
                imageButton.widthAnchor.constraint(equalToConstant: 30),
                
                gpsButton.leadingAnchor.constraint(equalTo: imageButton.trailingAnchor, constant: 8),
                gpsButton.topAnchor.constraint(equalTo: topAnchor, constant: 2),
                gpsButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -2),
                gpsButton.widthAnchor.constraint(equalToConstant: 30),

                
                inputTextFiled.leadingAnchor.constraint(equalTo: gpsButton.trailingAnchor, constant: 8),
                inputTextFiled.topAnchor.constraint(equalTo: topAnchor, constant: 2),
                inputTextFiled.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -2),
                
                sendButton.leadingAnchor.constraint(equalTo: inputTextFiled.trailingAnchor, constant: 8),
                sendButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
                sendButton.topAnchor.constraint(equalTo: topAnchor, constant: 2),
                sendButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -2),
                sendButton.widthAnchor.constraint(equalToConstant: 30),
                
            ]
            NSLayoutConstraint.activate(constraints)
            
        
    }
}
