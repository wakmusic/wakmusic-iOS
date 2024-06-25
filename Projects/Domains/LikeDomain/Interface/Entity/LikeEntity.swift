//
//  LikeEntity.swift
//  DomainModule
//
//  Created by YoungK on 2023/04/03.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation

public struct LikeEntity {
    public init(
        status: String,
        likes: Int,
        description: String = ""
    ) {
        self.status = status
        self.likes = likes
        self.description = description
    }

    public let status: String
    public let likes: Int
    public var description: String = ""
}
