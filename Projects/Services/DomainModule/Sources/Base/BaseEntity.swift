//
//  BaseEntity.swift
//  DomainModule
//
//  Created by KTH on 2023/02/18.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation

public struct BaseEntity {
    public init(
        status: Int,
        description: String = ""
    ) {
        self.status = status
        self.description = description
    }

    public let status: Int
    public var description: String = ""
}
