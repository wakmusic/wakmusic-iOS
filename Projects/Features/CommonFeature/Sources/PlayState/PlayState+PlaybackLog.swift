//
//  PlayState+PlaybackLog.swift
//  CommonFeature
//
//  Created by KTH on 2023/08/27.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation

public extension PlayState {
    struct PlaybackLog: Codable {
        public var os: String = "ios"
        public var prev: PlayState.PlaybackLog.Previous
        public var curr: PlayState.PlaybackLog.Current
    }
}

public extension PlayState.PlaybackLog {
    struct Previous: Codable {
        public var songId: String
        public var songLength: Int
        public var stoppedAt: Int
    }

    struct Current: Codable {
        public var songId: String
    }
}
