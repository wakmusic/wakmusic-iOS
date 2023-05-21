//
//  ArtistListResponseDTO.swift
//  DataMappingModule
//
//  Created by KTH on 2023/02/01.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation

public struct QnaResponseDTO: Decodable {
    public let createAt: Int
    public let question, description: String
    public let category: QnaResponseDTO.Category?

    private enum CodingKeys: String, CodingKey {
        case createAt, question, description, category
    }
}

public extension QnaResponseDTO {
    struct Category: Codable {
        public let type: String
        public let category: String
    }
}
