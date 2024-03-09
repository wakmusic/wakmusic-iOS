//
//  SearchResultEntity.swift
//  DomainModule
//
//  Created by yongbeomkwak on 12/9/23.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation

public struct SearchResultEntity: Equatable {
    public init(song: [SongEntity], artist: [SongEntity], remix: [SongEntity]) {
        self.song = song
        self.artist = artist
        self.remix = remix
    }

    public let song, artist, remix: [SongEntity]
}
