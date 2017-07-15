//
//  AppDelegate.swift
//  Core Data
//
//  Created by Pulkit on 6/26/17.
//  Copyright © 2017 Pulkeet. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        

        getRecordFromCoreData()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics   
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "Core_Data")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        let modelURL = Bundle.main.url(forResource: "Core_Data", withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
        
    lazy var managedObjectContext: NSManagedObjectContext = {
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    
    lazy var applicationDocumentsDirectory: NSURL = {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count-1] as NSURL
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.appendingPathComponent("SingleViewCoreData.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil)
        } catch {
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data" as AnyObject
            dict[NSLocalizedFailureReasonErrorKey] = failureReason as AnyObject
            
            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
    }()
    

    //MARK:
    //MARK: Get Record
    func getRecordFromCoreData(){
        
        let result = fetchRecord(strEntity: "Person")
        if (result != nil && (result?.count)! > 0) {
            let person = result?[0] as! NSManagedObject
            
            print(person.value(forKey: "fullname") ?? "")
            print(person.value(forKey: "lastname") ?? "")
            print(person.value(forKey: "name") ?? "")
            print(person.value(forKey: "addresses") ?? "")

            
          //  applyRelationship(coreDataObj: person)
            
        }
        
    }
    //MARK:
    //MARK: Create Managed Object
    // Insert Record
    func createRecord(){
        
        let entityDescription = NSEntityDescription.entity(forEntityName: "Person", in: self.managedObjectContext)
        let newPerson = NSManagedObject(entity: entityDescription!, insertInto: self.managedObjectContext)
        newPerson.setValue("Ravi Jada Khodabhai", forKey: "fullname")
        newPerson.setValue("Jada", forKey: "lastname")
        newPerson.setValue("Ravi", forKey: "name")
        
        
        saveRecord(coreDataObj: newPerson)
        
    }
    
    //MARK:
    //MARK: CoreData Supportive
    func fetchRecord(strEntity : String)->[Any]?{
        
        // Initialize Fetch Request
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        
        // Create Entity Description
        let entityDescription = NSEntityDescription.entity(forEntityName: strEntity, in: self.managedObjectContext)
        
        // Configure Fetch Request
        fetchRequest.entity = entityDescription
        
        do {
            let result = try self.managedObjectContext.fetch(fetchRequest)
            print(result)
            return result
            
        } catch {
            let fetchError = error as NSError
            print(fetchError)
            return nil

        }
    }
    
    func saveRecord(coreDataObj: NSManagedObject){
        do {
            try coreDataObj.managedObjectContext?.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func deleteRecord(coreDataObj: NSManagedObject){
        self.managedObjectContext.delete(coreDataObj)
        
        do {
            try self.managedObjectContext.save()
        } catch {
            let saveError = error as NSError
            print(saveError)
        }
    }
    
    
    func applyRelationship(coreDataObj: NSManagedObject){
        
        
        // Create Address
        let entityAddress = NSEntityDescription.entity(forEntityName: "Address", in: self.managedObjectContext)
        let newAddress = NSManagedObject(entity: entityAddress!, insertInto: self.managedObjectContext)
        
        // Populate Address
        newAddress.setValue("Main Street", forKey: "street")
        newAddress.setValue("Boston", forKey: "city")
        
        // Add Address to Person
        coreDataObj.setValue(NSSet(object: newAddress), forKey: "addresses")
        
        do {
            try coreDataObj.managedObjectContext?.save()
        } catch {
            let saveError = error as NSError
            print(saveError)
        }
    }
    

}

