//
//  SongEntity.swift
//  DomainModule
//
//  Created by KTH on 2024/03/11.
//  Copyright © 2024 yongbeomkwak. All rights reserved.
//

import Foundation

public struct SongEntity: Equatable {
    public init(
        id: String,
        title: String,
        artist: String,
        remix: String,
        reaction: String,
        views: Int,
        last: Int,
        date: String,
        isSelected: Bool = false
    ) {
        self.id = id
        self.title = title
        self.artist = artist
        self.remix = remix
        self.reaction = reaction
        self.views = views
        self.last = last
        self.date = date
        self.isSelected = isSelected
    }

    public let id, title, artist, remix: String
    public let reaction: String
    public let views, last: Int
    public let date: String
    public var isSelected: Bool

    public static func == (lhs: SongEntity, rhs: SongEntity) -> Bool {
        lhs.id == rhs.id
    }
}
