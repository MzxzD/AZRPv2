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
import RealmSwift

class HomeViewModel: HomeViewModelProtocol, WebSocketDelegate {
    //    var downloadTrigger: ReplaySubject<Bool>
    //    var searchTrigger: ReplaySubject<Bool>
    //    var searchWithInputTrigger: ReplaySubject<Bool>
    var realmServise = RealmSerivce()
    var refreshPublisher: ReplaySubject<Bool>
    
    var socketController: WebSocketController
    //    var message: SendMessageRequest!
    var roomMessages : [RoomMessages] = []
    //    var realmRoomMessages : [RoomMessages] = []
    var dataIsReady : PublishSubject<TableRefresh>
    //    var loader: PublishSubject<Bool>
    var error: PublishSubject<String>
    
    init() {
        self.dataIsReady = PublishSubject<TableRefresh>()
        self.refreshPublisher = ReplaySubject<Bool>.create(bufferSize: 1)
        //        self.downloadTrigger = ReplaySubject<Bool>.create(bufferSize: 1)
        //        self.searchTrigger = ReplaySubject<Bool>.create(bufferSize: 1)
        //        self.searchWithInputTrigger = ReplaySubject<Bool>.create(bufferSize: 1)
        self.error = PublishSubject<String>()
        //        self.roomMessages = []
        
        //        self.loader = PublishSubject<Bool>()
        //        self.message = SendMessageRequest()
        self.socketController = WebSocketController()
        self.socketController.socket.delegate = self
        self.socketController.socket.connect()
        //        self.token = getTokenFromData()
        
    }
    
    func getStoredRooms() -> Disposable {
        let realmObaerverTrigger = refreshPublisher
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [unowned self] (event) in
                if event {
                    self.roomMessages.removeAll()
                    
                    let realmRooms = self.realmServise.realm.objects(RoomMessages.self)
                    for room in realmRooms {
                        self.roomMessages += [room]
                        print(self.roomMessages.count)
                    }
                    //                    self.refreshView.onNext(TableRefresh.complete)
                    //                    self.refreshPublisher.onNext(false)
                    self.dataIsReady.onNext(.complete)
                }
            })
        return realmObaerverTrigger
    }
    
    
    
    private func serialize(data: Data) -> (MessageObject?, RoomObject?) {
        let jsonDecoder = JSONDecoder()
        var message: MessageObject? = nil
        var room: RoomObject? = nil
        
        
        do{
            let data = try jsonDecoder.decode(MessageObject.self, from: data)
            //            guard let messageData = newMessage.attr.content else { return }
            message = data
            //            print(data)
        } catch {
            
            do {
                let data = try jsonDecoder.decode(RoomObject.self, from: data)
                room = data
                print(data)
            } catch let error {
                self.error.onNext(error.localizedDescription)
            }
            
        }
        
        return (message, room)
        
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
        //        let decoder = JSONDecoder()
        let roomMessage = RoomMessages()
        var message: MessageObject!
        
        let messageRoomTuple: (message: MessageObject?, room:RoomObject?) = serialize(data: responseData!)
        
        switch messageRoomTuple {
        case (nil, nil):
            self.error.onNext("Parsing Failed")
        default:
            if messageRoomTuple.message == nil {
                //            roomMessage.roomObject = messageRoomTuple.room
                // NEW ROOM
                roomMessage.roomObject = messageRoomTuple.room
                let new : RoomMessages = roomMessage
                if (!self.realmServise.update(object: new)){
                    self.error.onNext("Error saving new Room")
                }
                self.refreshPublisher.onNext(true)
                
                
            }else {
                // Message in existing room
                message = messageRoomTuple.message
                var newRoom: [RoomMessages] = self.roomMessages
                for (index, element) in self.roomMessages.enumerated(){
                    if element.roomObject?.attr.id == message.attr.room {
                        let realmID = element.roomID
                        self.roomMessages[index].messages += [message]
                        newRoom = self.roomMessages
                        let lol = self.realmServise.realm.object(ofType: RoomMessages.self, forPrimaryKey: realmID)
                        if (!self.realmServise.deleteMessageObject(object: (lol?.messages.first)!)) {
                            self.error.onNext("YOU FAILURE")
                        }
                        if (!self.realmServise.update(object: lol!)) {
                            self.error.onNext("BOOOO!")
                        }
                        self.refreshPublisher.onNext(true)
                        
                    }
                }
                for element in newRoom{
                    if(!self.realmServise.create(object: element)){
                        self.error.onNext("ErrorSaving new message")
                    }
                }
                self.refreshPublisher.onNext(true)
                
            }
        }
        
        
        
        
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
    func getStoredRooms() -> Disposable
}






