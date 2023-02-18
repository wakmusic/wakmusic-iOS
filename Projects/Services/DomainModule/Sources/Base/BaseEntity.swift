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
        status: Int
    ) {
        self.status = status
    }
    
    public let status: Int
}
