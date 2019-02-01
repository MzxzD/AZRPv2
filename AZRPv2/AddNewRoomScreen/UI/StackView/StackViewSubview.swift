//
//  StackViewSubview.swift
//  AZRPv2
//
//  Created by Mateo Doslic on 12/01/2019.
//  Copyright © 2019 Mateo Doslic. All rights reserved.
//

import Foundation
import UIKit

class StackViewSubview: UIView {
    var stackViewDelegate: StackSubviewDelegate!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
//        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let deleteButton : UIButton = {
        var button = UIButton()
        button.setTitle("X", for: .normal )
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
        
    }()
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
        
        
    }()
    @objc func deleteButtonPressed() {
        // DOESNT WORK!
        guard let username = self.usernameLabel.text else {return}
        self.stackViewDelegate.removeSelectedUser(name: username)
        self.removeFromSuperview()
    }
    
   
    
    private func setupUI() {
        deleteButton.addTarget(self, action: #selector(deleteButtonPressed), for: .touchDown)
        self.addSubview(usernameLabel)
        self.addSubview(deleteButton)
        setupConstraints()
        
    }
    
    private func setupConstraints() {
        let constraints = [
            
//            usernameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
//            usernameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            
            deleteButton.widthAnchor.constraint(equalToConstant: self.bounds.width ),
            deleteButton.heightAnchor.constraint(equalToConstant: self.bounds.height)
//            deleteButton.topAnchor.constraint(equalTo: topAnchor, constant: 1),
//            deleteButton.trailingAnchor.constraint(equalTo: usernameLabel.trailingAnchor, constant: -1)
            ]
        NSLayoutConstraint.activate(constraints)

    }
    
    override func layoutIfNeeded() {
        setupUI()
    }
}
