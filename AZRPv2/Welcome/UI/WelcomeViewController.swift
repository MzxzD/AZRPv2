//
//  LoginViewController.swift
//  AZRPv2
//
//  Created by Mateo Doslic on 30/12/2018.
//  Copyright © 2018 Mateo Doslic. All rights reserved.
//

import UIKit
import CoreData
import RxSwift

class WelcomeViewController: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    let disposeBag = DisposeBag()
    var loginView: LoginView!
    var registerView: RegistrationView!
    var welcomeViewModel: WelcomeViewModel!
    
    var loginButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Login", for: .normal)
        button.setTitleColor(UIColor.blue, for: .normal)
//        button.frame = CGRect(x: 0, y: 0, width: 60, height: 20)
        button.addTarget(self, action: #selector(showLoginForm), for: .touchUpInside)
        return button
    }()
    
    var registerButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Register", for: .normal)
        button.setTitleColor(UIColor.blue, for: .normal)
//        button.frame = CGRect(x: 0, y: 0, width: 60, height: 20)
        button.addTarget(self, action: #selector(showRegisterForm), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()

        // Do any additional setup after loading the view.
    }
    
    func initializeAutentificationObserver() {
        let authObserver = loginView.loginViewModel.authTrigger
        authObserver
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
        .observeOn(MainScheduler.instance)
            .subscribe(onNext: { (event) in
                if event {
                    self.welcomeViewModel.openHomeScreen()
                }
            })
        .disposed(by: disposeBag)
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        
        view.addSubviews(loginButton, registerButton)
        //        loginView.alpha = 0
        //        registerView.alpha = 0
        setupConstraints()
    }
    
    private func setupConstraints() {
        var constraints: [NSLayoutConstraint] = []
        if loginView != nil {
            constraints += [
                loginView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
                loginView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0),
                loginView.widthAnchor.constraint(equalToConstant: 150),
                loginView.heightAnchor.constraint(equalToConstant: 150)
            ]
        }
         if registerView != nil {
            
            constraints += [
                registerView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
                registerView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0),
                registerView.widthAnchor.constraint(equalToConstant: 150),
                registerView.heightAnchor.constraint(equalToConstant: 150)
            ]
            
        }
            constraints += [
                loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
                loginButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -20),
                
                registerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
                registerButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 20)
            ]
        
        
        NSLayoutConstraint.activate(constraints)
    }
    
    @objc func showLoginForm() {
        if registerView != nil {
            registerView = nil
        }
        self.loginView = LoginView()
        let VM = LoginViewModel()
        loginView.loginViewModel = VM
        loginView.loginViewModel.getDataFromApi().disposed(by: disposeBag)
        loginView.loginViewModel.error
            .asObservable()
            .map { text -> String? in
                return Optional(text)
            }
            .bind(to: loginView.usernameErrorLabel.rx.text)
            .disposed(by: disposeBag)
        initializeAutentificationObserver()
        loginView.alpha = 0
//        loginButton.fadeOut()
//        registerButton.fadeOut()
//        loginButton.removeFromSuperview()
//        registerButton.removeFromSuperview()
        view.addSubview(loginView)
        self.setupConstraints()
//        self.view.setNeedsLayout()
        loginView.fadeIn(0.6)

    }
    
    
    @objc func showRegisterForm() {
        if loginView != nil {
            loginView = nil
        }
        self.registerView = RegistrationView()
        registerView.alpha = 0
        //        loginButton.fadeOut()
        //        registerButton.fadeOut()
        //        loginButton.removeFromSuperview()
        //        registerButton.removeFromSuperview()
        view.addSubview(registerView)
        self.setupConstraints()
        registerView.fadeIn(0.6)
    }
}
