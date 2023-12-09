//
//  FetchLikeTransfer.swift
//  NetworkModuleTests
//
//  Created by YoungK on 2023/04/03.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation
import DataMappingModule
import DomainModule
import Utility

public extension LikeResponseDTO {
    func toDomain() -> LikeEntity {
        LikeEntity(
            status: status ?? 200,
            likes: likes
        )
    }
}

public extension FetchLikeResponseDTO {
    func toDomain() -> LikeEntity {
        LikeEntity(status: 200, likes: like)
    }
}
