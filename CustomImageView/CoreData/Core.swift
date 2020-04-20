//
//  CIVExtension.swift
//  CustomImageView
//
//  Created by Kautsya Kanu on 18/01/20.
//  Copyright © 2020 Kautsya Kanu. All rights reserved.
//

import UIKit
import CoreData

extension CustomImageView {
    func fetchCoreImage(with urlString: String, on context: NSManagedObjectContext,
                        completion: @escaping (ImageData) -> Void) {
        if let coreImage = getCoreImage(with: urlString, on: context) {
            let imageData = ImageData(urlString: urlString,
                                      image: coreImage, source: .core)
            completion(imageData)
            return
        }
        
        DispatchQueue.global(qos: .userInteractive).async {
            [weak self] in
            guard let self = self else { return }
            self.fetchRemoteImage(from: urlString, completion: {
                imageData in
                self.save(imageData, in: context)
                completion(imageData)
            })
        }
    }
    
    private func getCoreImage(with urlString: String,
                              on context: NSManagedObjectContext) -> UIImage? {
        let request = CIVImage.fetchAll(in: context)
        let predicate = NSPredicate(format: "urlString == %@", urlString)
        request.predicate = predicate
        request.fetchLimit = 1
        if let coreImage = try? context.fetch(request).first,
            !self.isExpired(coreImage),
            let coreImageData = coreImage.data as Data?,
            let uiImage = UIImage(data: coreImageData) {
            return uiImage
        }
        return nil
    }
    
    private func isExpired(_ civImage: CIVImage) -> Bool {
        let date = civImage.persistanceDate as Date
        if expirationTime != -1 && date.seconds(from: Date()) > expirationTime {
            delete(civImage)
            return true
        }
        return false
    }
    
    private func save(_ imageData: ImageData, in context: NSManagedObjectContext) {
        CoreDataManager.performOnBackground({
            context in
            CIVImage.insert(imageData, in: context)
            try? context.save()
        })
    }
    
    private func delete(_ civImage: CIVImage) {
        CoreDataManager.performOnBackground({
            context in
            context.delete(civImage)
            try? context.save()
        })
    }
}
