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
        image_square_version: Int,
        image_round_version: Int,
        version: Int
    ) {
        self.key = key
        self.title = title
        self.songs = songs
        self.image = image
        self.image_round_version = image_round_version
        self.image_square_version = image_square_version
        self.version = version
    }

    public let key, title: String
    public let songs: [SongEntity]
    public let image: String
    public let image_round_version, image_square_version, version: Int
}
