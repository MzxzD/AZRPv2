//
//  HomeViewModel.swift
//  Base MVVM Project
//
//  Created by Matija Solić on 04/08/2018.
//  Copyright © 2018 Factory. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import SocketIO
import Starscream
import CoreData

class HomeViewModel: HomeViewModelProtocol, WebSocketDelegate {
    var downloadTrigger: ReplaySubject<Bool>
    var searchTrigger: ReplaySubject<Bool>
    var searchWithInputTrigger: ReplaySubject<Bool>
    var dataIsReady: PublishSubject<Bool>
    let username: String
    let pass: String
    var token: String!
    var socket: WebSocket!
    var message: SendMessageRequest!
    
    
    init() {
        username = "admin"
        pass = "admin"
        self.dataIsReady = PublishSubject<Bool>()
        self.downloadTrigger = ReplaySubject<Bool>.create(bufferSize: 1)
        self.searchTrigger = ReplaySubject<Bool>.create(bufferSize: 1)
        self.searchWithInputTrigger = ReplaySubject<Bool>.create(bufferSize: 1)
        self.message = SendMessageRequest()
        self.token = getTokenFromData()
    }
    
    func getTokenFromData() -> String {
        var user: NSManagedObject!
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return .empty }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "AZRPUser")
        do {
            user = try managedContext.fetch(fetchRequest).first
        } catch let error as NSError {
            print("Error occured while fetching items", error)
        }
        
        return user.value(forKey: "token") as! String
        
    }
    
    //    func fillUpMessage(message: String) -> SendMessageRequest {
    //        var attributes = Attr()
    //        attributes.room = 1
    //        attributes.content = message
    //        attributes.object = ObjectType.message.rawValue
    //        attributes.senderUnique = self.username + "_" + randomString(length: 4)
    //        var message = SendMessageRequest()
    //        message.type = SendMessageType.create.rawValue
    //        message.attr = attributes
    //        return message
    //    }
    
    func initiateWebSocket(){
        self.createWebSocket(lastRoomID: -1, LastMessageID: -1)
    }
    
    private func createWebSocket(lastRoomID: Int, LastMessageID: Int) {
        self.socket = WebSocket(url: URL(string: "ws://0.0.0.0:8000/"+self.token+"/"+String(lastRoomID)+"/"+String(LastMessageID)+"/")!)
        self.socket.delegate = self
        socket.connect()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            if (self.socket.isConnected){
                //  self.sendMessage(message: "evo super sam...")
            }
        }
    }
    
    //    func getDataFromApi() -> Disposable {
    //        let downloadObserverTrigger = downloadTrigger.flatMap { (_) -> Observable<DataWrapper<LogIn>> in
    //            return APIService().fetchDataFromApI(username: self.username, pass: self.pass)
    //        }
    //
    //        return downloadObserverTrigger
    //            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
    //            .observeOn(MainScheduler.instance)
    //            .subscribe(onNext: { [unowned self](downloadedData) in
    //                if downloadedData.error == nil {
    //                    self.token = (downloadedData.data?.token)!
    //                    self.dataIsReady.onNext(true)
    ////                    print(downloadedData.data)
    //                    self.createWebSocket(lastRoomID: -1, LastMessageID: -1)
    //
    //                } else {
    //                    print("boooo")
    //                }
    //            })
    //    }
    
    //    func getUsersFromAPI() -> Disposable {
    //        let downloadObserverTrigger = searchTrigger.flatMap { (_) -> Observable<DataWrapper<Users>> in
    //            return APIService().getUsers(token: self.token)
    //        }
    //
    //        return downloadObserverTrigger
    //            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
    //            .observeOn(MainScheduler.instance)
    //            .subscribe(onNext: { [unowned self](downloadedData) in
    //                if downloadedData.error == nil {
    //                    self.dataIsReady.onNext(true)
    //         //           print(downloadedData.data)
    //                } else {
    //                    print("boooo")
    //                }
    //            })
    //    }
    
    //    func getUsersFromAPI(searchQuerry: String) -> Disposable {
    //        let downloadObserverTrigger = searchWithInputTrigger.flatMap { (_) -> Observable<DataWrapper<Users>> in
    //            return APIService().getUsers(token: self.token, searchQuerry: "admin")
    //        }
    //
    //        return downloadObserverTrigger
    //            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
    //            .observeOn(MainScheduler.instance)
    //            .subscribe(onNext: { [unowned self](downloadedData) in
    //                if downloadedData.error == nil {
    //                    self.dataIsReady.onNext(true)
    //                  //  print(downloadedData.data)
    //                } else {
    //                    print("boooo")
    //                }
    //            })
    //    }
    
    //    func startDownload() {
    //        downloadTrigger.onNext(true)
    //    }
    
    func websocketDidConnect(socket: WebSocketClient) {
        print("websocket is connected")
    }
    
    func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
        print("websocket is disconnected: \(String(describing: error?.localizedDescription))")
        //        print(error)
    }
    
    func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
//        print("got some text: \(text)")
        let responseData = text.data(using: String.Encoding.utf8)
        let newMessage: MessageObject!
        do{
            let data = try JSONDecoder().decode(MessageObject.self, from: responseData!)
            newMessage = data
            guard let messageData = newMessage.attr.content else { return }
            
            print(messageData)
        } catch let error {
            print(error)
        }

//        print(newMessage.attr.roomName)
        
        // Proveri text i odluci da li je message ili room
        // nakon toga posebne metode za to
    }
    
    func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
        print("got some data: \(data.count)")
        
    }
    
    //    func sendMessage(message: String) {
    //        self.socket.write(string: prepareObjectForSending(message: fillUpMessage(message: message)))
    //    }
    
    //    func prepareObjectForSending(message: SendMessageRequest) -> String {
    //        let jsonEncoder = JSONEncoder()
    //        let jsonData = try! jsonEncoder.encode(message)
    //        let json = String(data: jsonData, encoding: String.Encoding.utf8)
    //        return json ?? .empty
    //    }
}

protocol HomeViewModelProtocol {
    var downloadTrigger : ReplaySubject<Bool> {get}
    var dataIsReady : PublishSubject<Bool> {get}
    func initiateWebSocket()
    //    func startDownload()
    //    func getDataFromApi() -> Disposable
    //    func getUsersFromAPI() -> Disposable
    //    func getUsersFromAPI(searchQuerry: String) -> Disposable
    
}
