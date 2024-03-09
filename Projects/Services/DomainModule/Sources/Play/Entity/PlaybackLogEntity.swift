//
//  PostPlaybackLogEntity.swift
//  DomainModuleTests
//
//  Created by KTH on 2023/08/27.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation

public struct PlaybackLogEntity: Equatable {
    public init(
        id: String,
        title: String,
        artist: String
    ) {
        self.id = id
        self.title = title
        self.artist = artist
    }

    public let id, title, artist: String

    public static func == (lhs: PlaybackLogEntity, rhs: PlaybackLogEntity) -> Bool {
        lhs.id == rhs.id
    }
}
