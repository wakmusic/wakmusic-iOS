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
        id: String
    ) {
        self.id = id
    }
    public let id: String
}
