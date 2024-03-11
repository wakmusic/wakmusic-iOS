//
//  RecommendPlayListEntity.swift
//  DomainModuleTests
//
//  Created by yongbeomkwak on 2023/02/10.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation

public struct EditPlayListNameEntity: Equatable {
    public init(
        title: String,
        status: Int,
        description: String = ""
    ) {
        self.title = title
        self.status = status
        self.description = description
    }

    public let status: Int
    public let title, description: String
}
