//
//  HomeViewController.swift
//  AZRPv2
//
//  Created by Mateo Doslic on 01/01/2019.
//  Copyright © 2019 Mateo Doslic. All rights reserved.
//

import UIKit
import RxSwift
import Starscream

class HomeViewController: UITableViewController,TableRefreshView,LoaderViewProtocol  {

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    let disposeBag = DisposeBag()
    var viewModel: HomeViewModelProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Flack"
        initializeData()
        setupTableView()
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    self.viewModel.fetchSavedRooms()

    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
        
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.viewModel.realmRooms.count
    }

    
    private func setupTableView() {
        let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
        self.navigationItem.rightBarButtonItem = add
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(GroupTableViewCell.self, forCellReuseIdentifier: "GroupIdentifier")
//        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 75
        tableView.backgroundColor = UIColor(red: 237/255, green: 237/255, blue: 237/255, alpha: 1)
        tableView.separatorStyle = .none
    }
    
    private func initializeData() {
        initializeRefreshDriver(refreshObservable: viewModel.dataIsReady)
        self.viewModel.getStoredRooms().disposed(by: disposeBag)
//        initializeLoaderObserver(viewModel.loader)
        initializeError()
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
    
    @objc func addTapped() {
        viewModel.presentAddNewRoomView()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroupIdentifier", for: indexPath) as! GroupTableViewCell
        let group = self.viewModel.realmRooms[indexPath.row].messages.last
        cell.GroupNameLabel.text = group?.roomName ?? .empty
        cell.lastMessageLabel.text = group?.content ?? .empty
        cell.timeLabel.text = dayStringFromTime(unixTime: (group?.time ?? 1) / 1000) + " " +  timeStringFromUnixTime(unixTime: (group?.time ?? 1) / 1000)
        cell.userNameLabel.text = (group?.sender ?? .empty) + " : "
        cell.roomLogoLabel.text = String((group?.roomName?.first ?? Character(" ")))
        cell.layer.borderColor = UIColor(red: 237/255, green: 237/255, blue: 237/255, alpha: 1).cgColor
        cell.layer.borderWidth = 3
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.viewModel.openChatScreen(selectedRoom: indexPath.row)
    }
 
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
