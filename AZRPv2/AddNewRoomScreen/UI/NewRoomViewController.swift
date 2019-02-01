//
//  NewRoomViewController.swift
//  AZRPv2
//
//  Created by Mateo Doslic on 11/01/2019.
//  Copyright © 2019 Mateo Doslic. All rights reserved.
//
import Foundation
import UIKit
import RxSwift

let cellIdentifier = "CellID"
class NewRoomViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, TableRefreshView,LoaderViewProtocol {
    
    var viewModel: NewRoomViewModelProtocol!
    let disposeBag = DisposeBag()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Room name:"
        return label
        
    }()
    
    let roomNameTextField : UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.layer.borderColor = UIColor.black.cgColor
        textField.layer.borderWidth = 1
        return textField
    }()
    
    let participantsTextField : UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.layer.borderColor = UIColor.black.cgColor
        textField.layer.borderWidth = 1
        textField.allowsEditingTextAttributes = true
        return textField
    }()
    
    var tableView: UITableView! = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        let blurEffect = UIBlurEffect(style: .regular)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        table.separatorEffect = UIVibrancyEffect(blurEffect: blurEffect )
        table.backgroundView = blurEffectView
        return table
    }()
    
    let stackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .fillEqually
        stack.axis = .horizontal
        stack.alignment = .leading
        return stack
    }()
    
    
    let doneButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.imageView?.image = #imageLiteral(resourceName: "done")
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(doneButtonPressed), for: .touchUpInside)
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 1
        return button
    }()
    
    let cancelButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.imageView?.image = #imageLiteral(resourceName: "cancel")
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(cancelButtonPressed), for: .touchUpInside)
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 1
        return button
    }()
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.participants.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! UserTableViewCell
        let userItem = viewModel.participants[indexPath.row]
        
        cell.nameLabel.text = userItem.username
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let label = StackViewSubview()
        label.stackViewDelegate = viewModel
        let selectedUser = viewModel.participants[indexPath.row]
        label.usernameLabel.text = selectedUser.username
        self.stackView.addArrangedSubview(label)
        self.viewModel.selectedParticipants.append(selectedUser)
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 25
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeData()
        initializeError()
        setupView()
        // Do any additional setup after loading the view.
    }
    
    private func initializeData(){
        participantsTextField.delegate = self
        initializeRefreshDriver(refreshObservable: viewModel.dataIsReady)
        self.viewModel.getDataFromApi().disposed(by: disposeBag)
        self.viewModel.roomName
            .asObservable()
            .map { [unowned self] (text) -> String in
                self.viewModel.selectedRoomName = text
                return text
            }
            .bind(to: self.roomNameTextField.rx.text)
            .disposed(by: disposeBag)
        
        
        participantsTextField.rx.text.orEmpty
            .distinctUntilChanged({ (first, second) -> Bool in
                return  first == second
            })
            .skip(1) // skip first value
            .debounce(RxTimeInterval(0.5), scheduler: ConcurrentDispatchQueueScheduler(qos: .background)) //Time in seconds
            .asDriver(onErrorJustReturn: .empty) // Operacija se radi na mainThread-u
            .do(onNext: {[unowned self] (text) in
                self.viewModel.getUsers(name: text)
                
            })
            .drive()
            .disposed(by: disposeBag)
            }
    
    func initializeError() {
        let errorObserver = viewModel.error
        errorObserver
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [unowned self] (event) in
                ErrorAlertController().alert(viewToPresent: self, title: .empty, message: event)
            })
            .disposed(by: disposeBag)
    }

//    func initializeDownloadObserver() {
//        let downloadTrigger = viewModel.downloadTrigger
//            downloadTrigger
//            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
//            .observeOn(MainScheduler.instance)
//            .subscribe(onNext: { (event) in
//                if event {
//                    self.welcomeViewModel.openHomeScreen()
//                }
//            })
//            .disposed(by: disposeBag)
//    }
    
    
    @objc func cancelButtonPressed(){
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func doneButtonPressed(){
        self.viewModel.createRoom(roomName: self.roomNameTextField.text ?? .empty)
        self.dismiss(animated: true, completion: nil)
    }
    
    
    private func setupView() {
        
//        if !UIAccessibility.isReduceTransparencyEnabled {
//            let blurEffect = UIBlurEffect(style: .regular )
//            let blurEffectView = UIVisualEffectView(effect: blurEffect)
//            blurEffectView.translatesAutoresizingMaskIntoConstraints = false
//            blurEffectView.frame = self.view.bounds
//            self.view.addSubview(blurEffectView)
//            blurEffectView.isHidden = false
//            view.addSubview(blurEffectView.contentView)
//
//        } else {
            view.backgroundColor = .white
//        }
        setupTableView()
        view.addSubviews(nameLabel, roomNameTextField, participantsTextField, stackView, tableView, doneButton, cancelButton )
        
        setupConstraints()
        
    }
    
    private func setupTableView(){
        tableView.register(UserTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func setupConstraints() {
        //        let constraints = [
        nameLabel.topAnchor.constraint(equalTo: self.view!.topAnchor, constant: 28).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: (self.view?.leadingAnchor)!, constant: 8).isActive = true
        
        roomNameTextField.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8).isActive = true
        roomNameTextField.leadingAnchor.constraint(equalTo: view!.leadingAnchor, constant: 8).isActive = true
        roomNameTextField.trailingAnchor.constraint(equalTo: view!.trailingAnchor, constant: -8).isActive = true
        
        participantsTextField.topAnchor.constraint(equalTo: roomNameTextField.bottomAnchor, constant: 16).isActive = true
        participantsTextField.leadingAnchor.constraint(equalTo: view!.leadingAnchor, constant: 8).isActive = true
        participantsTextField.trailingAnchor.constraint(equalTo: view!.trailingAnchor, constant: -8).isActive = true
        
        
        stackView.topAnchor.constraint(equalTo: participantsTextField.bottomAnchor, constant: 8).isActive = true
        stackView.leadingAnchor.constraint(equalTo: view!.leadingAnchor, constant: 8).isActive = true
        stackView.trailingAnchor.constraint(equalTo: view!.trailingAnchor, constant: -8).isActive = true
        stackView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        tableView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        tableView.widthAnchor.constraint(equalToConstant: view.bounds.width).isActive = true
        tableView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 8).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view!.leadingAnchor, constant: 8).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view!.trailingAnchor, constant: -8).isActive = true
        
        doneButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        doneButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        doneButton.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 8).isActive = true
        doneButton.trailingAnchor.constraint(equalTo: view!.trailingAnchor, constant: -8).isActive = true
        
        cancelButton.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 8).isActive = true
        cancelButton.leadingAnchor.constraint(equalTo: view!.leadingAnchor, constant: 8).isActive = true
        cancelButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        cancelButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
    }
    
}
