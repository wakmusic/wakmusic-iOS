//
//  RecommendPlayListResponseDTO.swift
//  DataMappingModuleTests
//
//  Created by yongbeomkwak on 2023/02/10.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation
import Utility

public struct SinglePlayListDetailResponseDTO: Decodable {
    public let key: String?
    public let title: String
    public let songs: [SingleSongResponseDTO]?
    public let image: SinglePlayListDetailResponseDTO.Image
}

public extension SinglePlayListDetailResponseDTO {
    struct Image: Decodable {
        public let round: Int?
        public let square: Int?
        public let name: String?
        public let version: Int?
    }
}

#warning("임시코드")
public struct SingleSongResponseDTO: Decodable {
    public let id, title, artist, remix, reaction: String
    public let date, start, end: Int
    public let total: SingleSongResponseDTO.Total?

    enum CodingKeys: String, CodingKey {
        case title, artist, remix, reaction, date, start, end, total
        case id = "songId"
    }
}

public extension SingleSongResponseDTO {
    struct Total: Decodable {
        public let views, last: Int
        public let increase: Int?
    }
}
