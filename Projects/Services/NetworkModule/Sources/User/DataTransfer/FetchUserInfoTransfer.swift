//
//  FetchUserInfoTransfer.swift
//  NetworkModule
//
//  Created by yongbeomkwak on 12/8/23.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation
import DataMappingModule
import DomainModule
import Utility

public extension FetchUserResponseDTO {
    func toDomain() -> UserInfoEntity {
        UserInfoEntity(
            id: id,
            platform: platform,
            name: name,
            profile: profile?.type ?? "",
            version: profile?.version ?? 0
        )
    }
}
