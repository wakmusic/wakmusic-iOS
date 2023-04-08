//
//  Extension+Double.swift
//  Utility
//
//  Created by KTH on 2023/04/08.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation

public extension Double {
    var unixTimeToDate: Date {
        return Date(timeIntervalSince1970: TimeInterval(truncating: NSNumber(value: self)))
    }
}
