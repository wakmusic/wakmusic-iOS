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
        songID: String,
        title: String,
        artist: String,
        date: String,
        isSelected: Bool
    ) {
        self.songID = songID
        self.title = title
        self.artist = artist
        self.date = date
        self.isSelected = isSelected
    }

    public static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.songID == rhs.songID
    }

    public let songID, title, artist, date: String
    public var isSelected: Bool = false
}
