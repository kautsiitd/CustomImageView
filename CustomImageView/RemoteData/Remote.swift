//
//  CIVExtension.swift
//  CustomImageView
//
//  Created by Kautsya Kanu on 18/01/20.
//  Copyright © 2020 Kautsya Kanu. All rights reserved.
//

import UIKit

extension CustomImageView {
    func fetchRemoteImage(from urlString: String,
                          completion: @escaping (ImageData) -> Void) {
        var imageData = ImageData(urlString: urlString, image: noImage, source: .remote)
        guard let url = URL(string: urlString), url.isSafe() else {
            completion(imageData)
            return
        }
        
        let session = URLSession.shared
        session.dataTask(with: url, completionHandler: {
            data, response, error in
            guard let data = data,
                let remoteImage = UIImage(data: data) else {
                    completion(imageData)
                    return
            }
            imageData.image = remoteImage
            completion(imageData)
        }).resume()
    }
}
