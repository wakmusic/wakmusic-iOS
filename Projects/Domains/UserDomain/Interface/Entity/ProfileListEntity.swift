//
//  ProfileListEntity.swift
//  DomainModule
//
//  Created by KTH on 2023/02/18.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation

public struct ProfileListEntity: Equatable {
    public init(
        type: String,
        version: Int,
        isSelected: Bool
    ) {
        self.type = type
        self.version = version
        self.isSelected = false
    }

    public let type: String
    public var isSelected: Bool
    public var version: Int
}
