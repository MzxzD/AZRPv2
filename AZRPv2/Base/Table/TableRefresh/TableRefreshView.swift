//
//  TableRefreshView.swift
//  AZRPv2
//
//  Created by Mateo Doslic on 01/01/2019.
//  Copyright © 2019 Mateo Doslic. All rights reserved.
//

import Foundation
import RxSwift
protocol TableRefreshView {
    var tableView: UITableView! {get}
    var disposeBag: DisposeBag {get}
    func initializeRefreshDriver(refreshObservable: Observable<TableRefresh>)
}
/**
 Extension that handles cell refreshes
 
 Setup :
 In TableView controller call initializeRefreshDriver(refreshObservable: Observable<TableRefresh>) where  refreshObservable is refreshObserverable from TableRefreshViewModelProcotol.
 
 In class that implements TableRefreshViewModelProcotol emit one of the TableRefresh events.
 Check reloadTable method for more info.
 If necessery, it's it possible to override reloadTable method and implement custom reload scenarios.
 */
extension TableRefreshView where  Self:UIViewController{
    
    internal func initializeRefreshDriver(refreshObservable: Observable<TableRefresh>){
        refreshObservable
            .asDriver(onErrorJustReturn: TableRefresh.dontRefresh)
            .do(onNext: { [unowned self] (tableRefresh) in
                self.reloadTable(tableRefresh: tableRefresh, tableView: self.tableView)
            })
            .drive()
            .disposed(by: disposeBag)
    }
    func reloadTable(tableRefresh: TableRefresh, tableView: UITableView){
        switch(tableRefresh){
        case .complete:
            debugPrint("reloading table for \(self)")
            tableView.reloadData()
        case .addSection(let index):
            let index = IndexSet(integer: index)
            tableView.insertSections(index, with: .automatic)
            debugPrint("add table section with index : \(index) for \(self)")
        case .addRows(let indexPaths, let animation):
            if(animation == .none){
                let lastScrollOffset = tableView.contentOffset
                UIView.setAnimationsEnabled(false)
                tableView.beginUpdates()
                tableView.insertRows(at: indexPaths, with: .none)
                tableView.endUpdates()
                tableView.layer.removeAllAnimations()
                tableView.setContentOffset(lastScrollOffset, animated: false)
                UIView.setAnimationsEnabled(true)
                debugPrint("insert table rows with index : \(indexPaths) without animation for \(self)" )
            }else{
                tableView.insertRows(at: indexPaths, with: animation)
                debugPrint("insert table rows with index : \(indexPaths) for \(self)")
            }
            
            
        case .removeRows(let indexPaths, let animation):
            tableView.deleteRows(at: indexPaths, with: animation)
            debugPrint("delete table rows with index : \(indexPaths) for \(self)")
        case .removeSection(let index):
            let index = IndexSet(integer: index)
            tableView.deleteSections(index, with: .automatic)
            debugPrint("remove table section with index : \(index) for \(self)")
        case .section(let index, let animation):
            let index = IndexSet(integer: index)
            tableView.reloadSections(index, with: animation)
            debugPrint("reloading table section with index : \(index) for \(self)")
        case .reloadRows(let indexPaths):
            debugPrint("reloading table rows with index : \(indexPaths) for \(self)")
            tableView.reloadRows(at: indexPaths, with: .none)
        case .multipleActions(let removeIndexes, let addIndexes, let modifiedIndexes):
            let lastScrollOffset = tableView.contentOffset
            UIView.setAnimationsEnabled(false)
            tableView.beginUpdates()
            tableView.deleteRows(at: removeIndexes, with: .none)
            tableView.reloadRows(at: modifiedIndexes, with: .none)
            tableView.insertRows(at: addIndexes, with: .none)
            tableView.endUpdates()
            
            tableView.layer.removeAllAnimations()
            tableView.setContentOffset(lastScrollOffset, animated: false)
            UIView.setAnimationsEnabled(true)
            debugPrint("multiple operations on table without animation for \(self)" )
        default:
            return
        }
    }
}
