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
        ID: String,
        title: String,
        artist: String,
        remix: String,
        reaction: String,
        date: Int,
        views: Int,
        last: Int
    ){
        self.ID = ID
        self.title = title
        self.artist = artist
        self.remix = remix
        self.reaction = reaction
        self.date = date
        self.views = views
        self.last = last
    }
    
    public static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.ID == rhs.ID
    }
    
    public let ID, title, artist, remix, reaction: String
    public let date, views, last: Int
}
