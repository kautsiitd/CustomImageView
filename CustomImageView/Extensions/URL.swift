//
//  URL.swift
//  NewsApp
//
//  Created by Kautsya Kanu on 03/01/20.
//  Copyright © 2020 Kautsya Kanu. All rights reserved.
//

import Foundation

extension URL {
    func isSafe() -> Bool {
        return self.absoluteString.starts(with: "https://")
    }
}
