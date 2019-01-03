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

    
    let disposeBag = DisposeBag()
    var viewModel: HomeViewModelProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "MIMMS AZRP"
        initializeData()
        setupTableView()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
        
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.viewModel.roomMessages.count
    }

    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(GroupTableViewCell.self, forCellReuseIdentifier: "GroupIdentifier")
//        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
    }
    
    private func initializeData() {
        initializeRefreshDriver(refreshObservable: viewModel.dataIsReady)
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
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroupIdentifier", for: indexPath) as! GroupTableViewCell
        let group = self.viewModel.roomMessages[indexPath.row]
        if let name = group.roomObject?.type {
            cell.GroupNameLabel.text = name
        }
//        cell.GroupNameLabel.text = group.roomObject!.attr?.name
//        cell.lastMessageLabel.text = group.
//        cell.timeLabel.text = dayStringFromTime(unixTime: (group.messages.last?.attr.time ?? 1) / 1000) + " " +  timeStringFromUnixTime(unixTime: (group.messages.last?.attr.time ?? 1) / 1000)
//        cell.userNameLabel.text = (group.messages.last?.attr.sender ?? .empty) + " : "
        return cell
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
