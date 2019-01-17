//
//  NewRoomViewModel.swift
//  AZRPv2
//
//  Created by Mateo Doslic on 11/01/2019.
//  Copyright © 2019 Mateo Doslic. All rights reserved.
//

import Foundation
import Starscream
import CoreData
import RxSwift


class NewRoomViewModel: NewRoomViewModelProtocol {
    let socket: WebSocketController!
    var roomName: PublishSubject<String>
    var selectedRoomName: String
    var participateName: String = .empty
    var participants: Users = []
    var selectedParticipants: Users = []
    var downloadTrigger: ReplaySubject<Bool>
    var error: PublishSubject<String>
    var dataIsReady: PublishSubject<TableRefresh>

    
    init(socket: WebSocketController) {
        self.socket = socket
        self.roomName = PublishSubject<String>()
        self.downloadTrigger = ReplaySubject<Bool>.create(bufferSize: 1)
        self.error = PublishSubject<String>()
        self.dataIsReady = PublishSubject<TableRefresh>()
        self.selectedRoomName = .empty
    }
    
    func getDataFromApi() -> Disposable {
        let downloadObserverTrigger = downloadTrigger.flatMap { (_) -> Observable<DataWrapper<Users>> in
            return APIService().getUsers(token: getTokenFromData(), searchQuerry: self.participateName)
        }
        
        return downloadObserverTrigger
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [unowned self](downloadedData) in
                if downloadedData.error == nil {
                    guard let dataElements = downloadedData.data else {return}
                    for element in dataElements {
                        self.participants.append(element)
                        self.dataIsReady.onNext(.complete)
                    }
                } else {
                    self.error.onNext(downloadedData.error!)
                }
            })
    }

    
    func removeSelectedUser(name: String) {
        for (index, user) in self.selectedParticipants.enumerated() {
            if user.username == name {
                self.selectedParticipants.remove(at: index)
            }
        }
    }
    
    func createRoom(roomName: String) {
        self.selectedRoomName = roomName
        if validateInput() {
            let newRoom = prepareMessageToSend()
            let encodedMessage = prepareObjectForSending(object: newRoom)
            print(encodedMessage)
            socket.socket.write(string: encodedMessage)

        }else {
            error.onNext("Error, Some InputFields are empty")
        }
        
    }
    
    private func validateInput() -> Bool {
        if self.selectedRoomName == .empty || self.selectedParticipants.count < 1 {
            return false
        }else {
            return true
        }
    }
    
    private func prepareMessageToSend() -> NewRoom {
        var attributes = NewRoomAttr()
        attributes.name = self.selectedRoomName
        attributes.participants = getSelectedParticipantsID()
        attributes.senderUnique = getUsernameFromData() + "_" + randomString(length: 4)
        var room = NewRoom()
        room.attr = attributes
        
        return room
    }
    
    private func getSelectedParticipantsID() -> [Int]{
        var ids: [Int] = []
        for data in self.selectedParticipants{
            ids.append(data.id)
        }
        ids.append(getUserIDFromData())
        return ids
    }
    
    private func prepareObjectForSending(object: NewRoom) -> String {
        let jsonEncoder = JSONEncoder()
        let jsonData = try! jsonEncoder.encode(object)
        guard let json = String(data: jsonData, encoding: String.Encoding.utf8) else {return .empty}
        return json
    }
    
    func getUsers(name: String) {
        self.participants.removeAll()
        self.participateName = name
        self.downloadTrigger.onNext(true)
    }
    
}

protocol NewRoomViewModelProtocol: StackSubviewDelegate {
    var roomName: PublishSubject<String> {get set}
    func getUsers(name: String)
    var downloadTrigger: ReplaySubject<Bool> {get}
    var error: PublishSubject<String> {get}
    var dataIsReady: PublishSubject<TableRefresh> {get}
    var participants: Users {get}
    func getDataFromApi() -> Disposable
    var selectedParticipants: Users {get set}
    func createRoom(roomName: String)
    var selectedRoomName: String {get set}

    
}

protocol StackSubviewDelegate {
    func removeSelectedUser(name: String)
}
