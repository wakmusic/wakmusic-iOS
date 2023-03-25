//
//  RepeatMode.swift
//  PlayerFeature
//
//  Created by YoungK on 2023/03/25.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation

enum RepeatMode {
    case none
    case repeatAll
    case repeatOnce
    
    mutating func rotate() {
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
