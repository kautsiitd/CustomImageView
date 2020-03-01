//
//  Date.swift
//  CustomImageView
//
//  Created by Kautsya Kanu on 10/02/20.
//  Copyright © 2020 Kautsya Kanu. All rights reserved.
//

import Foundation

extension Date {
    func seconds(from date: Date) -> Int {
        return Calendar.current.dateComponents([.second], from: self, to: date).second ?? 0
    }
}
