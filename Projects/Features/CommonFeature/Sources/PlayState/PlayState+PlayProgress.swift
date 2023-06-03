//
//  PlayState+PlayProgress.swift
//  CommonFeature
//
//  Created by YoungK on 2023/04/03.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation

extension PlayState {
    public struct PlayProgress {
        public var currentProgress: Double = 0
        public var endProgress: Double = 0
        
        public mutating func clear() {
            currentProgress = 0
            endProgress = 0
        }

        public mutating func resetCurrentProgress() {
            currentProgress = 0
        }
    }
}
