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
        let momdName = "CustomImageView"
        let modelURL = Bundle(for: type(of: self)).url(forResource: momdName, withExtension:"momd")!
        let mom = NSManagedObjectModel(contentsOf: modelURL)!
        let container = NSPersistentContainer(name: momdName, managedObjectModel: mom)
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
