//
//  FetchLikeTransfer.swift
//  NetworkModuleTests
//
//  Created by YoungK on 2023/04/03.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import DataMappingModule
import DomainModule
import Foundation
import Utility

public extension LikeResponseDTO {
    func toDomain() -> LikeEntity {
        LikeEntity(
            status: status ?? 200,
            likes: like
        )
    }
}

public extension FetchLikeResponseDTO {
    func toDomain() -> LikeEntity {
        LikeEntity(status: 200, likes: like)
    }
}
