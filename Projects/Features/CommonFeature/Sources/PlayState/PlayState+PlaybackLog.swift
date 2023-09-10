//
//  PlayState+PlaybackLog.swift
//  CommonFeature
//
//  Created by KTH on 2023/08/27.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation

extension PlayState {
    public struct PlaybackLog: Codable {
        public var os: String = "ios"
        public var prev: PlayState.PlaybackLog.Previous
        public var curr: PlayState.PlaybackLog.Current
    }
}

extension PlayState.PlaybackLog {
    public struct Previous: Codable {
        public var songId: String
        public var songLength: Int
        public var stoppedAt: Int
    }
    public struct Current: Codable {
        public var songId: String
    }
}
