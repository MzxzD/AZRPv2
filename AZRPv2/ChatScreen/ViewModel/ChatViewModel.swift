//
//  ChatViewModel.swift
//  AZRPv2
//
//  Created by Mateo Doslic on 05/01/2019.
//  Copyright © 2019 Mateo Doslic. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class ChatViewModel: ChatViewModelProtocol {
    var room: Room
    var username: String = .empty
    weak var coordinatorDelegate: ChatCoordinatorDelegate?
    
    init(room: Room) {
        self.room = room
        self.username = getUsernameFromData()
    }
    func openImagePicker(imagePicker: UIImagePickerController) {
        coordinatorDelegate?.presentImagePicker(imagePicker: imagePicker)
    }
    
    
    func sortChatBubbles(messagePosition: Int) -> Bool {
        let message = self.room.messages[messagePosition]
        if message.sender == self.username {
            return true
        }else {
            return false
        }
    }
    
    
    
}

extension ChatViewModel {
    
    private func getUsernameFromData() -> String {
        var user: NSManagedObject!
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return .empty }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "AZRPUser")
        do {
            user = try managedContext.fetch(fetchRequest).first
        } catch let error as NSError {
            print("Error occured while fetching items", error)
        }
        
        return user.value(forKey: "username") as! String
        
    }
    
    
}

protocol ChatViewModelProtocol: CollectionViewCellDelegate {
    var room: Room {get}
    func openImagePicker(imagePicker: UIImagePickerController)
    var coordinatorDelegate: ChatCoordinatorDelegate? {get set}
}

public protocol CollectionViewCellDelegate: class {
    func sortChatBubbles(messagePosition: Int) -> Bool
}

public protocol KeyBoardViewDelegate: class {
    func sendMessage()
    
}

public protocol LocationDelegate: class {
    func getLocation()
}

public protocol ImageDelegate: class {
    func getImage()
}
