//
//  CoreDataStack.swift
//  NewsApp
//
//  Created by Kautsya Kanu on 06/12/19.
//  Copyright © 2019 Kautsya Kanu. All rights reserved.
//

import Foundation
import UIKit
import CoreData

let imageCache = NSCache<NSString, UIImage>()

class CoreDataManager {
    //MARK: Properties
    static let shared = CoreDataManager()
    private init() {
        imageCache.countLimit = 40
        let request = CIVImage.fetchAll()
        _ = try? privateContext.fetch(request)
    }
    
    private lazy var managedObjectModel: NSManagedObjectModel = {
        let bundle = Bundle(for: type(of: self))
        let modelURL = bundle.url(forResource: "CIV", withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    
    private lazy var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CIV", managedObjectModel: managedObjectModel)
        container.loadPersistentStores(completionHandler: {
            (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    lazy var privateContext: NSManagedObjectContext = {
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.persistentStoreCoordinator = container.persistentStoreCoordinator
        return context
    }()
}

//MARK:- Available Functions
extension CoreDataManager {
    func saveAllData() {
        privateContext.perform {
            if self.privateContext.hasChanges {
                try? self.privateContext.save()
            }
        }
    }
    
    func deleteOldData() {
        privateContext.perform {
            let imageDeleteRequest = CIVImage.deleteAll()
            _ = try? self.privateContext.execute(imageDeleteRequest)
        }
    }
}
