//
//  Image.swift
//  CustomImageView
//
//  Created by Kautsya Kanu on 17/01/20.
//  Copyright © 2020 Kautsya Kanu. All rights reserved.
//

import UIKit

extension UIImage {
    func resize(to size: CGSize) -> UIImage {
        let imageRenderer = UIGraphicsImageRenderer(size: size, format: imageRendererFormat)
        let reducedImage = imageRenderer.image { _ in
            draw(in: CGRect(origin: .zero, size: size))
        }
        return reducedImage
    }
}
