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
        id: String,
        krName: String,
        enName: String,
        groupName: String,
        title: String,
        description: String,
        personalColor: String,
        roundImage: String,
        squareImage: String,
        graduated: Bool,
        isHiddenItem: Bool
    ) {
        self.id = id
        self.krName = krName
        self.enName = enName
        self.groupName = groupName
        self.title = title
        self.description = description
        self.personalColor = personalColor
        self.roundImage = roundImage
        self.squareImage = squareImage
        self.graduated = graduated
        self.isHiddenItem = isHiddenItem
    }

    public static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.id == rhs.id
    }

    public let id, krName, enName, groupName: String
    public let title, description: String
    public let personalColor: String
    public let roundImage, squareImage: String
    public let graduated: Bool
    public var isHiddenItem: Bool = false
}
