//
//  CIVExtension.swift
//  CustomImageView
//
//  Created by Kautsya Kanu on 18/01/20.
//  Copyright © 2020 Kautsya Kanu. All rights reserved.
//

extension CustomImageView {
    func fetchCacheImage(from urlString: String,
                         completion: @escaping (ImageData) -> Void) {
        if let cachedImage = imageCache.object(forKey: urlString as NSString) {
            let imageData = ImageData(urlString: urlString,
                                      image: cachedImage, source: .cache)
            completion(imageData)
            return
        }
        
        if shouldPersist {
            CoreDataManager.performOnMain({
                context in
                self.fetchCoreImage(with: urlString, on: context, completion: {
                    imageData in
                    imageCache.setObject(imageData.image, forKey: urlString as NSString)
                    completion(imageData)
                })
            })
        } else {
            fetchRemoteImage(from: urlString, completion: {
                imageData in
                imageCache.setObject(imageData.image, forKey: urlString as NSString)
                completion(imageData)
            })
        }
    }
}
