//
//  LikeResponseDTO.swift
//  DataMappingModuleTests
//
//  Created by YoungK on 2023/04/03.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation
import LikeDomainInterface

public struct LikeResponseDTO: Decodable {
    public let status: Int?
    public let like: Int
}

public extension LikeResponseDTO {
    func toDomain() -> LikeEntity {
        LikeEntity(
            status: status ?? 200,
            likes: like
        )
    }
}
