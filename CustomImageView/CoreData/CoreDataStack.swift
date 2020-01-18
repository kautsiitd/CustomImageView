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

class CoreDataStack {
    //MARK: Properties
    static let shared = CoreDataStack()
    private init() {
        imageCache.countLimit = 40
    }
    
    //MARK: Available
    lazy var persistentContainer: NSPersistentContainer = {
        let coreDataName = "CIV"
        let bundle = Bundle(for: type(of: self))
        let modelURL = bundle.url(forResource: coreDataName, withExtension:"momd")!
        let model = NSManagedObjectModel(contentsOf: modelURL)!
        let container = NSPersistentContainer(name: coreDataName, managedObjectModel: model)
        container.loadPersistentStores(completionHandler: {
            (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
}

extension CoreDataStack {
    func save() {
        let context = persistentContainer.viewContext
        if context.hasChanges { try? context.save() }
    }
}
