//
//  RecommendPlayListResponseDTO.swift
//  DataMappingModuleTests
//
//  Created by yongbeomkwak on 2023/02/10.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation
import PlayListDomainInterface

public struct SingleRecommendPlayListResponseDTO: Decodable {
    public let key, title: String
    public let image: SingleRecommendPlayListResponseDTO.Image
}

public extension SingleRecommendPlayListResponseDTO {
    struct Image: Codable {
        public let round: Int
        public let square: Int
    }
}

public extension SingleRecommendPlayListResponseDTO {
    func toDomain() -> RecommendPlayListEntity {
        RecommendPlayListEntity(
            key: key,
            title: title,
            image_round_version: image.round,
            image_sqaure_version: image.square
        )
    }
}
