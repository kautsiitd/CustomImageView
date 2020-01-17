//
//  Image.swift
//  NewsApp
//
//  Created by Kautsya Kanu on 31/12/19.
//  Copyright © 2019 Kautsya Kanu. All rights reserved.
//

import Foundation
import CoreData

public class Image: NSManagedObject {
    //MARK: Properties
    @NSManaged var urlString: String
    @NSManaged var data: NSData?
    
    @nonobjc public class func fetchAll() -> NSFetchRequest<Image> {
        let fetchRequest = NSFetchRequest<Image>()
        let context = CoreDataStack.shared.persistentContainer.viewContext
        let entityDescription = NSEntityDescription.entity(forEntityName: "\(Image.self)", in: context)
        fetchRequest.entity = entityDescription
        return fetchRequest
    }
    
    @nonobjc public class func deleteAll() -> NSBatchDeleteRequest {
        let fetchRequest = Image.fetchAll()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest as! NSFetchRequest<NSFetchRequestResult>)
        return deleteRequest
    }
}
