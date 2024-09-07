//
//  ArtistListResponseDTO.swift
//  DataMappingModule
//
//  Created by KTH on 2023/02/01.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import FaqDomainInterface
import Foundation

public struct FaqResponseDTO: Decodable {
    public let question, answer: String
    public let category: String

    private enum CodingKeys: String, CodingKey {
        case question, answer, category
    }
}

public extension FaqResponseDTO {
    func toDomain() -> FaqEntity {
        FaqEntity(
            category: category,
            question: question,
            answer: answer,
            isOpen: false
        )
    }
}
