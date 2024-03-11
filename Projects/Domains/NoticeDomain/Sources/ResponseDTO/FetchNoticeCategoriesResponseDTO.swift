//
//  FetchNoticeCategoriesResponseDTO.swift
//  DataMappingModule
//
//  Created by KTH on 2023/04/08.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation
import NoticeDomainInterface

public struct FetchNoticeCategoriesResponseDTO: Decodable {
    public let categories: [String]?
}

public extension FetchNoticeCategoriesResponseDTO {
    func toDomain() -> FetchNoticeCategoriesEntity {
        return FetchNoticeCategoriesEntity(
            categories: categories ?? []
        )
    }
}
