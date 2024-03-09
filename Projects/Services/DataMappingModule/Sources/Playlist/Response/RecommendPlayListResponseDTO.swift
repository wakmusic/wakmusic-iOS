//
//  RecommendPlayListResponseDTO.swift
//  DataMappingModuleTests
//
//  Created by yongbeomkwak on 2023/02/10.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation

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
