//
//  ChartEntity.swift
//  ChartDomainInterface
//
//  Created by KTH on 5/16/24.
//  Copyright © 2024 yongbeomkwak. All rights reserved.
//

import Foundation

public struct ChartEntity {
    public init(
        updatedAt: String,
        songs: [ChartRankingEntity]
    ) {
        self.updatedAt = updatedAt
        self.songs = songs
    }

    public let updatedAt: String
    public let songs: [ChartRankingEntity]
}
