//
//  RecommendPlayListEntity.swift
//  DomainModuleTests
//
//  Created by yongbeomkwak on 2023/02/10.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation

public struct AuthLoginEntity: Equatable {
    public init(
        token: String
    ) {
        self.token = token
    }

    public let token: String
}
