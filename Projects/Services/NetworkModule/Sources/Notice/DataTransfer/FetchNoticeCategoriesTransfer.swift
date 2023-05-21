//
//  FetchNoticeCategoriesTransfer.swift
//  NetworkModuleTests
//
//  Created by KTH on 2023/04/08.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation
import DataMappingModule
import DomainModule

public extension FetchNoticeCategoriesResponseDTO {
    func toDomain() -> FetchNoticeCategoriesEntity {
        FetchNoticeCategoriesEntity(
            type: type,
            category: category
        )
    }
}
