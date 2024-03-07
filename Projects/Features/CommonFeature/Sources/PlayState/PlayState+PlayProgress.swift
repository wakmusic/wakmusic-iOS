//
//  PlayState+PlayProgress.swift
//  CommonFeature
//
//  Created by YoungK on 2023/04/03.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation

public struct PlayProgress {
    public var currentProgress: Double
    public var endProgress: Double

    public init(currentProgress: Double = 0, endProgress: Double = 0) {
        self.currentProgress = currentProgress
        self.endProgress = endProgress
    }

    public mutating func clear() {
        currentProgress = 0
        endProgress = 0
    }

    public mutating func resetCurrentProgress() {
        currentProgress = 0
    }
}
