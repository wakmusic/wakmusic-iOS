//
//  AppCheckEntity.swift
//  AppDomain
//
//  Created by KTH on 2024/03/04.
//  Copyright © 2024 yongbeomkwak. All rights reserved.
//

import Foundation

public struct AppCheckEntity: Equatable {
    public init(
        flag: AppCheckFlagType,
        title: String,
        description: String,
        version: String,
        specialLogo: Bool
    ) {
        self.flag = flag
        self.title = title
        self.description = description
        self.version = version
        self.specialLogo = specialLogo
    }

    public let flag: AppCheckFlagType
    public let title, description, version: String
    public let specialLogo: Bool
}
