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
    public let status: String
    public let likes: Int

    private enum CodingKeys: String, CodingKey {
        case status
        case likes = "data"
    }
}

public extension LikeResponseDTO {
    func toDomain() -> LikeEntity {
        LikeEntity(
            status: status,
            likes: likes
        )
    }
}
