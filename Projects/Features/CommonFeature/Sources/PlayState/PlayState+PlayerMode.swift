//
//  PlayState+PlayerMode.swift
//  CommonFeature
//
//  Created by YoungK on 2023/04/01.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation

extension PlayState {
    public func switchPlayerMode(to mode: PlayerMode) {
        NotificationCenter.default.post(name: .updatePlayerMode, object: mode)
    }
}
