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
        if let coreImage = getCoreImage(with: urlString) {
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
        guard let coreImage = try? context.fetch(request).first,
            let coreImageData = coreImage.data as Data?,
            let uiImage = UIImage(data: coreImageData) else {
                return nil
        }
        return uiImage
    }
    
    private func save(_ imageData: ImageData) {
        let coreImage = CIVImage(context: context)
        coreImage.urlString = imageData.urlString
        coreImage.data = imageData.image.pngData() as NSData?
        try? context.save()
    }
}
