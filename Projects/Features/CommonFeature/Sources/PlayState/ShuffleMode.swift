//
//  ShuffleMode.swift
//  PlayerFeature
//
//  Created by YoungK on 2023/03/25.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation

public enum ShuffleMode {
    case on
    case off
    
    public var isOn: Bool { return self == .on }
    public  var isOff: Bool { return self == .off }
    
    public    mutating func toggle() {
        self = (self == .on) ? .off : .on
    }
}
