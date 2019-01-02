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
import Starscream

class HomeViewModel: HomeViewModelProtocol, WebSocketDelegate {
//    var downloadTrigger: ReplaySubject<Bool>
//    var searchTrigger: ReplaySubject<Bool>
//    var searchWithInputTrigger: ReplaySubject<Bool>
    var socketController: WebSocketController
//    var message: SendMessageRequest!
    var roomMessages : [RoomMessages] = []
    var dataIsReady : PublishSubject<TableRefresh>
//    var loader: PublishSubject<Bool>
    var error: PublishSubject<String>
    
    init() {
        self.dataIsReady = PublishSubject<TableRefresh>()
//        self.downloadTrigger = ReplaySubject<Bool>.create(bufferSize: 1)
//        self.searchTrigger = ReplaySubject<Bool>.create(bufferSize: 1)
//        self.searchWithInputTrigger = ReplaySubject<Bool>.create(bufferSize: 1)
        self.error = PublishSubject<String>()
//        self.loader = PublishSubject<Bool>()
//        self.message = SendMessageRequest()
        self.socketController = WebSocketController()
        self.socketController.socket.delegate = self
        self.socketController.socket.connect()
//        self.token = getTokenFromData()
        
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
    
    func websocketDidConnect(socket: WebSocketClient) {
        print("websocket is connected")
    }
    
    func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
        print("websocket is disconnected: \(String(describing: error?.localizedDescription))")
    }
    
    func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
//        print("got some text: \(text)")
        let responseData = text.data(using: String.Encoding.utf8)
        let decoder = JSONDecoder()
        var roomMessage = RoomMessages(roomObject: nil, messages: [])
        var message: MessageObject!
        do{
            let data = try decoder.decode(MessageObject.self, from: responseData!)
//            guard let messageData = newMessage.attr.content else { return }
            message = data
//            print(data)
        } catch {
            
            do {
                let data = try decoder.decode(RoomObject.self, from: responseData!)
                roomMessage.roomObject = data
            } catch let error {
                self.error.onNext(error.localizedDescription)
            }
            
        }
        if roomMessage.roomObject != nil {
            // Ddodaj u postojeći element
            self.roomMessages.append(roomMessage)
        }else {
            // kreirati novi table item!
            for (index, element) in self.roomMessages.enumerated(){
                if element.roomObject?.attr.id == message.attr.room {
                    self.roomMessages[index].messages.append(message)
                }
            }
            
        }
        self.dataIsReady.onNext(.complete)
        
//        roomMessage.roomObject
//        print(self.roomMessages.count)
//        print(self.roomMessages.last?.messages.last?.attr.content)
        
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
//    var downloadTrigger : ReplaySubject<Bool> {get}
    var dataIsReady : PublishSubject<TableRefresh> {get}
//    var loader: PublishSubject<Bool> {get}
    var roomMessages : [RoomMessages] {get}
    var error: PublishSubject<String> {get}
}
