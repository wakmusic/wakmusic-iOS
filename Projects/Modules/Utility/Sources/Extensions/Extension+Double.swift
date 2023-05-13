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
    var kilobytes: Double {
        return Double(self) / 1024
    }
    var megabytes: Double {
        return kilobytes / 1024
    }
    var gigabytes: Double {
        return megabytes / 1024
    }
}
