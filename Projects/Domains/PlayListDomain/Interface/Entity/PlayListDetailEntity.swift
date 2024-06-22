//
//  RecommendPlayListEntity.swift
//  DomainModuleTests
//
//  Created by yongbeomkwak on 2023/02/10.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation
import SongsDomainInterface

public struct PlayListDetailEntity: Equatable {
    public init(
        key: String,
        title: String,
        songs: [SongEntity],
        image: String,
        `private`: Bool

    ) {
        self.key = key
        self.title = title
        self.songs = songs
        self.image = image
        self.private = `private`
    }

    public let key, title: String
    public var songs: [SongEntity]
    public let image: String
    public let `private`: Bool
}
