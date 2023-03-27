//
//  ShuffleMode.swift
//  PlayerFeature
//
//  Created by YoungK on 2023/03/25.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation

enum ShuffleMode {
    case on
    case off
    
    var isOn: Bool { return self == .on }
    var isOff: Bool { return self == .off }
    
    mutating func toggle() {
        self = (self == .on) ? .off : .on
    }
}
