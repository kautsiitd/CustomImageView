//
//  CIVImage.swift
//  NewsApp
//
//  Created by Kautsya Kanu on 31/12/19.
//  Copyright © 2019 Kautsya Kanu. All rights reserved.
//

import Foundation
import CoreData

public class CIVImage: NSManagedObject {
    //MARK: Properties
    @NSManaged var urlString: String
    @NSManaged var data: NSData?
    @NSManaged var persistanceDate: NSDate
    
    static func insert(_ imageData: ImageData, in context: NSManagedObjectContext) {
        let civImage = CIVImage(context: context)
        civImage.urlString = imageData.urlString
        civImage.data = imageData.image.pngData() as NSData?
        civImage.persistanceDate = Date() as NSDate
    }
    
    @nonobjc public class func fetchAll(in context: NSManagedObjectContext) -> NSFetchRequest<CIVImage> {
        let fetchRequest = NSFetchRequest<CIVImage>()
        let entityDescription = NSEntityDescription.entity(forEntityName: "\(CIVImage.self)", in: context)
        fetchRequest.entity = entityDescription
        return fetchRequest
    }
    
    @nonobjc public class func deleteAll(in context: NSManagedObjectContext) -> NSBatchDeleteRequest {
        let fetchRequest = CIVImage.fetchAll(in: context)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest as! NSFetchRequest<NSFetchRequestResult>)
        return deleteRequest
    }
}
