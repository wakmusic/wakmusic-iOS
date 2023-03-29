//
//  RepeatMode.swift
//  PlayerFeature
//
//  Created by YoungK on 2023/03/25.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation

public enum RepeatMode {
    case none // 반복 없음
    case repeatAll // 전체 반복
    case repeatOnce // 한곡 반복
    
    public    mutating func rotate() {
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
