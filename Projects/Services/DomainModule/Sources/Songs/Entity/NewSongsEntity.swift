//
//  NewSongsEntity.swift
//  DomainModule
//
//  Created by KTH on 2023/11/15.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation

public struct NewSongsEntity: Equatable {
    public init(
        id: String,
        title: String,
        artist: String,
        remix: String,
        reaction: String,
        views: Int,
        last: Int,
        date: Int,
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
    public let date: Int
    public var isSelected: Bool
    
    public static func == (lhs: NewSongsEntity, rhs:  NewSongsEntity) -> Bool {
        lhs.id == rhs.id
    }
}
