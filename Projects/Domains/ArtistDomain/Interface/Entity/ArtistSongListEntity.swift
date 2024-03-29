//
//  ArtistSongListEntity.swift
//  DomainModule
//
//  Created by KTH on 2023/02/10.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation

public struct ArtistSongListEntity: Equatable {
    public init(
        songId: String,
        title: String,
        artist: String,
        remix: String,
        reaction: String,
        date: String,
        views: Int,
        last: Int,
        isSelected: Bool
    ) {
        self.songId = songId
        self.title = title
        self.artist = artist
        self.remix = remix
        self.reaction = reaction
        self.date = date
        self.views = views
        self.last = last
        self.isSelected = isSelected
    }

    public static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.songId == rhs.songId
    }

    public let songId, title, artist, remix, reaction, date: String
    public let views, last: Int
    public var isSelected: Bool = false
}
