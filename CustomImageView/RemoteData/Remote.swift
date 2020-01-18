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
        var imageData = ImageData(urlString: urlString, image: #imageLiteral(resourceName: "NoImage.png"), source: .remote)
        guard let url = URL(string: urlString), url.isSafe() else {
            completion(imageData)
            return
        }
        
        let session = URLSession.shared
        session.dataTask(with: url, completionHandler: {
            data, response, error in
            if let data = data,
                let remoteImage = UIImage(data: data) {
                imageData.image = remoteImage
                completion(imageData)
                return
            }
            completion(imageData)
        }).resume()
    }
}
