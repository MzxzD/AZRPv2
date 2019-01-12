//
//  RegisterViewModel.swift
//  AZRPv2
//
//  Created by Mateo Doslic on 30/12/2018.
//  Copyright © 2018 Mateo Doslic. All rights reserved.
//

import Foundation
import RxSwift
import CoreData
import Alamofire


class RegisterViewModel {
    var user: NSManagedObject!
    var downloadTrigger: ReplaySubject<Bool>
    var authTrigger: ReplaySubject<Bool>
    var error: PublishSubject<String>
    var username: String = .empty
    var pass: String = .empty
    var token: String = .empty
    var userExists: Exists!
    
    
    init() {
        self.downloadTrigger = ReplaySubject<Bool>.create(bufferSize: 1)
        self.authTrigger = ReplaySubject<Bool>.create(bufferSize: 1)
        self.error = PublishSubject<String>()
    }
    
//    func getResponseIfExists() -> Exists{
//        var user: Exists!
//        let downloadedData = APIService().doesUserAlreadyExists(username: self.username)
//        downloadedData.asObservable()
//        .map { (arg0) -> Exists in
//            let (data, _) = arg0
//            user = data
//            return Exists()
//        }
//
//        return user
//    }
    
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
                    item.setValue(downloadedData.data?.user.id, forKey: "id")
                    
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
    
    func startRegister(username: String, password: String){
        self.username = username
        self.pass = password
        downloadTrigger.onNext(true)
    }
    
 
    func doesUserAlreadyExists(registerName: String, completion : @escaping (Exists)-> (Void)) {
        let url = "http://0.0.0.0:8000/api/auth/user-exists/?username="+registerName

        Alamofire
            .request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil)
            .validate(statusCode: 200 ..< 500)
            .validate(contentType: ["application/json"])
            .responseData { (response) in
                let decoder = JSONDecoder()
                var APIResponse: Exists!
                do {
                    let data = try decoder.decode(Exists.self, from: response.data!)
                    APIResponse = data
                }catch let error {
                    print(error.localizedDescription)
                }
                self.userExists = APIResponse
                completion(APIResponse)

        }
    }
}
