//
//  FetchNoticeCategoriesTransfer.swift
//  NetworkModuleTests
//
//  Created by KTH on 2023/04/08.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import DataMappingModule
import DomainModule
import Foundation

public extension FetchNoticeCategoriesResponseDTO {
    func toDomain() -> FetchNoticeCategoriesEntity {
        return FetchNoticeCategoriesEntity(
            categories: categories ?? []
        )
    }
}
