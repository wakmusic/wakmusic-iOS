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
        id: String,
        isSelected: Bool
    ) {
        self.id = id
        self.isSelected = false
    }
    
    public let id: String
    public var isSelected: Bool
}
