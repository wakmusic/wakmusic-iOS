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
        date: String,
        isSelected: Bool = false,
        karaokeNumber: NewSongsEntity.KaraokeNumber = .init(TJ: nil, KY: nil)
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
        self.karaokeNumber = karaokeNumber
    }

    public let id, title, artist, remix: String
    public let reaction: String
    public let views, last: Int
    public let date: String
    public var isSelected: Bool
    public let karaokeNumber: NewSongsEntity.KaraokeNumber

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    public static func == (lhs: NewSongsEntity, rhs: NewSongsEntity) -> Bool {
        lhs.id == rhs.id
    }
}

public extension NewSongsEntity {
    struct KaraokeNumber {
        public init (TJ: Int?, KY: Int?) {
            self.TJ = TJ
            self.KY = KY
        }

        public let TJ, KY: Int?
    }
}
