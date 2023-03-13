//
//  ArtistListEntity.swift
//  DomainModule
//
//  Created by KTH on 2023/02/08.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation

public struct ArtistListEntity: Equatable {
    public init(
        ID: String,
        name: String,
        short: String,
        group: String,
        title: String,
        description: String,
        color: [[String]],
        youtube: String,
        twitch: String,
        instagram: String,
        imageRoundVersion: Int,
        imageSquareVersion: Int,
        isHiddenItem: Bool
    ) {
        self.ID = ID
        self.name = name
        self.short = short
        self.group = group
        self.title = title
        self.description = description
        self.color = color
        self.youtube = youtube
        self.twitch = twitch
        self.instagram = instagram
        self.imageRoundVersion = imageRoundVersion
        self.imageSquareVersion = imageSquareVersion
        self.isHiddenItem = isHiddenItem
    }
    
    public static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.ID == rhs.ID
    }
    
    public let ID, name, short, group: String
    public let title, description: String
    public let color: [[String]]
    public let youtube, twitch, instagram: String
    public let imageRoundVersion, imageSquareVersion: Int
    public var isHiddenItem: Bool = false
}
