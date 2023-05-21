//
//  FetchNoticeCategoriesEntity.swift
//  DomainModuleTests
//
//  Created by KTH on 2023/04/08.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation

public struct FetchNoticeCategoriesEntity: Codable {
    public init (
        type: String,
        category: String
    ) {
        self.type = type
        self.category = category
    }
    public let type: String
    public let category: String
}
