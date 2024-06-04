//
//  RecommendPlayListEntity.swift
//  DomainModuleTests
//
//  Created by yongbeomkwak on 2023/02/10.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation

public struct RecommendPlayListEntity: Hashable, Equatable {
    public init(
        key: String,
        title: String,
        image: String,
        `private`: Bool,
        count: Int
    ) {
        self.key = key
        self.title = title
        self.image = image
        self.private = `private`
        self.count = count
    }

    public let key, title, image: String
    public let `private`: Bool
    public let count: Int
    private let id = UUID()
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    public static func == (_ lhs:Self, _ rhs:Self) -> Bool {
        lhs.id == rhs.id
    }
    
}
