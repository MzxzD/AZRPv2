//
//  LoginView.swift
//  AZRPv2
//
//  Created by Mateo Doslic on 30/12/2018.
//  Copyright © 2018 Mateo Doslic. All rights reserved.
//

import Foundation
import UIKit
import RxSwift


class LoginView: UIView {
     let disposeBag = DisposeBag()
    var loginViewModel: LoginViewModel!
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var usernameTextField: UITextField = {
        let textField = UITextField()
        textField.setBottomBorder()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Username"
        return textField
        
    }()
    
    var usernameErrorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.red
        label.text = ""
        label.font = UIFont(name: "HelveticaNeue", size: CGFloat(10))
        //        label.text = "Error username not found"
        return label
    }()
    
    var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.setBottomBorder()
        textField.placeholder = "Password"
        textField.isSecureTextEntry = true
        return textField
        
    }()
    
    var passwordErrorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.red
        label.text = ""
        label.font = UIFont(name: "HelveticaNeue", size: CGFloat(10))
        //                label.text = "Error, Password incorrect"
        return label
    }()
    
    var loginButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Login", for: .normal)
        button.setTitleColor(UIColor.blue, for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 60, height: 20)
        button.addTarget(self, action: #selector(atemptToLogin), for: .touchUpInside)
        return button
        
    }()
    
    var backButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Back", for: .normal)
        button.setTitleColor(UIColor.blue, for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 60, height: 20)
        button.addTarget(self, action: #selector(removeLoginView), for: .touchUpInside)
        return button
        
    }()
    
    
    @objc func removeLoginView() {
        self.fadeOut(0.3)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            self.removeFromSuperview()
            
        }
    }
    
    @objc func atemptToLogin() {
        
        if usernameTextField.text == .empty {
            self.usernameTextField.isError(baseColor: UIColor.red.cgColor, numberOfShakes: 0, revert: true)
            self.usernameErrorLabel.text = "Empty username field"
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.usernameErrorLabel.text = .empty
                
            }
        }
        
        if passwordTextField.text == .empty {
            self.passwordTextField.isError(baseColor: UIColor.red.cgColor, numberOfShakes: 0, revert: true)
            self.passwordErrorLabel.text = "Empty password field"
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.passwordErrorLabel.text = .empty
            }
        }
        
        if usernameTextField.text != .empty && passwordTextField.text != .empty {
            loginViewModel.startLogin(username: usernameTextField.text!, password: passwordTextField.text!)
        }
        
        
    }
    
    private func setupUI() {

        self.backgroundColor = UIColor.white
        self.addSubviews(usernameTextField, usernameErrorLabel, passwordTextField, passwordErrorLabel, loginButton, backButton)
        setupConstraints()
    }
    
    private func setupConstraints() {
        let constraints = [
            usernameTextField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8),
            usernameTextField.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
            usernameTextField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8),
            
            usernameErrorLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8),
            usernameErrorLabel.topAnchor.constraint(equalTo: usernameTextField.bottomAnchor, constant: 3),
            usernameErrorLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8),
            
            passwordTextField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8),
            passwordTextField.topAnchor.constraint(equalTo: usernameErrorLabel.bottomAnchor, constant: 8),
            passwordTextField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8),
            
            passwordErrorLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8),
            passwordErrorLabel.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 3),
            passwordErrorLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8),
            
            loginButton.leadingAnchor.constraint(equalTo: backButton.trailingAnchor, constant: 8),
            loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 16),
            loginButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8),
            
            backButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8),
            backButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 16),
            backButton.trailingAnchor.constraint(equalTo: loginButton.leadingAnchor, constant: -8),
            
            ]
        NSLayoutConstraint.activate(constraints)
    }
}
