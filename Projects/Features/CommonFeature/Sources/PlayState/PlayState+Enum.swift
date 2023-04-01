//
//  PlayState+Enum.swift
//  CommonFeature
//
//  Created by YoungK on 2023/03/31.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation

public enum ShuffleMode {
    case on
    case off
    
    public var isOn: Bool { return self == .on }
    public  var isOff: Bool { return self == .off }
    
    public mutating func toggle() {
        self = (self == .on) ? .off : .on
    }
}

public enum RepeatMode {
    case none // 반복 없음
    case repeatAll // 전체 반복
    case repeatOnce // 한곡 반복
    
    public mutating func rotate() {
        switch self {
        case .none:
            self = .repeatAll
        case .repeatAll:
            self = .repeatOnce
        case .repeatOnce:
            self = .none
        }
    }
}

public enum PlayerMode: Equatable {
    case full
    case mini
    case close
}
