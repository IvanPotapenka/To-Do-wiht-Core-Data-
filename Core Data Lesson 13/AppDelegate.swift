//
//  AppDelegate.swift
//  Core Data Lesson 13
//
//  Created by PIY on 11.07.22.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

 // MARK: - Core Data stack

    func applicationWillTerminate(_ application: UIApplication) {
        saveContext()
    }
    
    lazy var persistentContainer: NSPersistentContainer = {
       
        
        let container = NSPersistentContainer(name: "Core_Data_Lesson_13")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
               
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

