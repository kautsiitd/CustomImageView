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
}

//MARK:- Available
extension CoreDataManager {
    /// For Writing to Disk in PrivateConcurrencyType
    static func performOnBackground(_ block: @escaping (NSManagedObjectContext) -> Void) {
        CoreDataManager.shared.container.performBackgroundTask(block)
    }
    /// For Writing into Main Context, Take care of async execution in block as context is MainConcurrencyType
    static func performOnMain(_ block: @escaping (NSManagedObjectContext) -> Void) {
        block(CoreDataManager.shared.container.viewContext)
    }

}
