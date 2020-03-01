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
    func fetchCoreImage(with urlString: String,
                        completion: @escaping (ImageData) -> Void) {
        if shouldPersist, let coreImage = getCoreImage(with: urlString) {
            let imageData = ImageData(urlString: urlString,
                                      image: coreImage, source: .core)
            completion(imageData)
            return
        }
        
        fetchRemoteImage(from: urlString, completion: {
            [weak self] imageData in
            guard let self = self else { return }
            if self.shouldPersist { self.save(imageData) }
            completion(imageData)
        })
    }
    
    private func getCoreImage(with urlString: String) -> UIImage? {
        let request = CIVImage.fetchAll()
        let predicate = NSPredicate(format: "urlString == %@", urlString)
        request.predicate = predicate
        request.fetchLimit = 1
        let context = CoreDataStack.shared.CIVContext
        if let coreImage = try? context.fetch(request).first,
            !isExpired(coreImage),
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
    
    private func save(_ imageData: ImageData) {
        let context = CoreDataStack.shared.CIVContext
        let coreImage = CIVImage(context: context)
        coreImage.urlString = imageData.urlString
        coreImage.data = imageData.image.pngData() as NSData?
        coreImage.persistanceDate = Date() as NSDate
        try? context.save()
    }
    
    private func delete(_ civImage: CIVImage) {
        let context = CoreDataStack.shared.CIVContext
        context.delete(civImage)
    }
}
