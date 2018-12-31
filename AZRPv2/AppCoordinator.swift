//
//  AppCoordinator.swift
//  Base MVVM Project
//
//  Created by Matija Solić on 04/08/2018.
//  Copyright © 2018 Factory. All rights reserved.
//

import UIKit
import CoreData
//import BaseKit
class AppCoordinator: Coordinator{
    var user: NSManagedObject!
    var childCoordinators: [Coordinator] = []
    let window: UIWindow
    //root navigation controller
    var presenter: UINavigationController
    init(window: UIWindow) {
        self.window = window
        presenter = UINavigationController()
        
    }
    
    func start() {
       
        window.rootViewController = presenter
        window.makeKeyAndVisible()
        FetchUserData()
        if user != nil {
            let homeCoordinator = HomeCoordinator(presenter: presenter)
            addChildCoordinator(childCoordinator: homeCoordinator)
            homeCoordinator.start()
        } else {
            let loginCoordinator = LoginCoordinator(presenter: presenter)
            addChildCoordinator(childCoordinator: loginCoordinator)
            loginCoordinator.start()
        }

    }
    
    
    func saveUserData(token: String, username: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "AZRPUser", in: managedContext)!
        let item = NSManagedObject(entity: entity, insertInto: managedContext)
        item.setValue(token, forKey: "token")
        item.setValue(username, forKey: "username")
        
        do {
            try managedContext.save()
            self.user = item
        }catch let error as NSError {
            print("Error:",error)
        }
        
    }
    
    func FetchUserData() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "AZRPUser")
        do {
            self.user = try managedContext.fetch(fetchRequest).first
        } catch let error as NSError {
            print("Error occured while fetching items", error)
        }
        
        
    }
}
