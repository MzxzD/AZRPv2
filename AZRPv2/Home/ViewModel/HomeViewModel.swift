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
import Realm

class HomeViewModel: HomeViewModelProtocol {
    var coordinatorDelegate: HomeCoordinatorDelegate?
    var realmRooms : [Room] = []
    var realmServise = RealmSerivce()
    var refreshPublisher: ReplaySubject<Bool>
    var dataIsReady : PublishSubject<TableRefresh>
    var error: PublishSubject<String>
    
    init() {
        self.dataIsReady = PublishSubject<TableRefresh>()
        self.refreshPublisher = ReplaySubject<Bool>.create(bufferSize: 1)
        self.error = PublishSubject<String>()
        
    }
    
    func getStoredRooms() -> Disposable {
        let realmObaerverTrigger = refreshPublisher
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [unowned self] (event) in
                if event {
                    self.realmRooms.removeAll()

                    let realmRooms = self.realmServise.realm.objects(Room.self)
                    for room in realmRooms {
                        self.realmRooms += [room]
                    }

                    self.realmRooms = self.realmRooms.sorted(by: { (roomOne, roomTwo) -> Bool in
                        let roomTimeOne: Double = roomOne.messages.last?.time ?? roomOne.time
                        let roomTimeTwo: Double = roomTwo.messages.last?.time ?? roomTwo.time
                        return roomTimeOne > roomTimeTwo
                    })
                    self.dataIsReady.onNext(.complete)
                }
            })
        return realmObaerverTrigger
    }
    
    func fetchSavedRooms() {
        self.refreshPublisher.onNext(true)
    }
    
    // MARK: Make way to do this

    func presentAddNewRoomView() {
        coordinatorDelegate?.presentNewRoomScreen()
    }

    
    // MARK: socket modification!
    
    func openChatScreen(selectedRoom: Int){
        self.coordinatorDelegate?.openChatScreen(roomID: self.realmRooms[selectedRoom].id)
    }
    
    
    
}

protocol HomeViewModelProtocol {
    var dataIsReady : PublishSubject<TableRefresh> {get}
    var realmRooms : [Room] {get}
    var coordinatorDelegate: HomeCoordinatorDelegate? {get set}
    var error: PublishSubject<String> {get}
    func getStoredRooms() -> Disposable
    func fetchSavedRooms()
    func openChatScreen(selectedRoom: Int)
    func presentAddNewRoomView()
}






