//
//  ArtistListResponseDTO.swift
//  DataMappingModule
//
//  Created by KTH on 2023/02/01.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation

public struct FaqResponseDTO: Decodable {
    public let question, description: String
    public let category: String

    private enum CodingKeys: String, CodingKey {
        case question, description, category
    }
}
