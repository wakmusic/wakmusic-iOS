//
//  FetchNoticeEntity.swift
//  DomainModuleTests
//
//  Created by KTH on 2023/04/08.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation

public struct FetchNoticeEntity {
    public init (
        id: Int,
        category: String,
        title: String,
        thumbnail: String?,
        content: String?,
        images: [String],
        createdAt: Double,
        startAt: Double,
        endAt: Double
    ) {
        self.id = id
        self.category = category
        self.title = title
        self.thumbnail = thumbnail
        self.content = content
        self.images = images
        self.createdAt = createdAt
        self.startAt = startAt
        self.endAt = endAt
    }

    public let id: Int
    public let category, title: String
    public let thumbnail: String?
    public let content: String?
    public let images: [String]
    public let createdAt, startAt, endAt: Double
}
