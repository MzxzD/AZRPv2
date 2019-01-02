//
//  WebSocket.swift
//  AZRPv2
//
//  Created by Mateo Doslic on 02/01/2019.
//  Copyright © 2019 Mateo Doslic. All rights reserved.
//

import Foundation
import SocketIO
import Starscream
import CoreData

class WebSocketController {
    
    var socket: WebSocket!
    
 
    init() {
        self.socket = self.createWebSocket()
    }
    
    private func createWebSocket() -> WebSocket {
        return WebSocket(url: URL(string: self.getWebSocketURL())!)
    }
    
    private func getWebSocketURL() -> String{
        // lastRoomID , LastMessageID
        // Implement Get method from CoreData or Realm!
        return  (WebSocketAdress().adress + self.getTokenFromData()+"/"+String(-1)+"/"+String(-1)+"/")
    }
    
   private func getTokenFromData() -> String {
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
    
}
