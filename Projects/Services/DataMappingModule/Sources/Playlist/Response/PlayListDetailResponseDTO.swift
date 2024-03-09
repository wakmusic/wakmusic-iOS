//
//  RecommendPlayListResponseDTO.swift
//  DataMappingModuleTests
//
//  Created by yongbeomkwak on 2023/02/10.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation

public struct SinglePlayListDetailResponseDTO: Decodable {
    public let key: String?
    public let title: String
    public let songs: [SingleSongResponseDTO]?
    public let image: SinglePlayListDetailResponseDTO.Image
}

public extension SinglePlayListDetailResponseDTO {
    struct Image: Codable {
        public let round: Int?
        public let square: Int?
        public let name: String?
        public let version: Int?
    }
}
