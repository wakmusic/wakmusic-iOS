//
//  FetchLikeResponseDTO.swift
//  DataMappingModule
//
//  Created by yongbeomkwak on 12/9/23.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation
import LikeDomainInterface

public struct FetchLikeResponseDTO: Decodable {
    public let songId: String
    public let like: Int
}

public extension FetchLikeResponseDTO {
    func toDomain() -> LikeEntity {
        LikeEntity(status: 200, likes: like)
    }
}
