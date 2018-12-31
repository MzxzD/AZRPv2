//
//  LoginViewModel.swift
//  AZRPv2
//
//  Created by Mateo Doslic on 30/12/2018.
//  Copyright © 2018 Mateo Doslic. All rights reserved.
//

import Foundation
import CoreData
import RxSwift


class LoginViewModel {
    var user: NSManagedObject!
    var downloadTrigger: ReplaySubject<Bool>
    var authTrigger: ReplaySubject<Bool>
    var error: PublishSubject<String>
    var username: String = .empty
    var pass: String = .empty
    var token: String = .empty

    
    init() {
        self.downloadTrigger = ReplaySubject<Bool>.create(bufferSize: 1)
        self.authTrigger = ReplaySubject<Bool>.create(bufferSize: 1)
        self.error = PublishSubject<String>()
    }
    
    func getDataFromApi() -> Disposable {
        let downloadObserverTrigger = downloadTrigger.flatMap { (_) -> Observable<DataWrapper<LogIn>> in
            return APIService().fetchDataFromApI(username: self.username, pass: self.pass)
        }
        
        return downloadObserverTrigger
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [unowned self](downloadedData) in
                if downloadedData.error == nil {
                    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
                    let managedContext = appDelegate.persistentContainer.viewContext
                    let entity = NSEntityDescription.entity(forEntityName: "AZRPUser", in: managedContext)!
                    let item = NSManagedObject(entity: entity, insertInto: managedContext)
                    item.setValue(downloadedData.data?.token, forKey: "token")
                    item.setValue(downloadedData.data?.user.name, forKey: "username")
                    
                    do {
                        try managedContext.save()
                        self.user = item
                    }catch let error as NSError {
                        print("Error:",error)
                    }
                    // Trigger to open HOME SCREEN!
                    self.authTrigger.onNext(true)
                    
                    
                } else {
                    self.error.onNext(downloadedData.error!)
                }
            })
    }
    
    func startLogin(username: String, password: String){
        self.username = username
        self.pass = password
        downloadTrigger.onNext(true)
    }
    
}
