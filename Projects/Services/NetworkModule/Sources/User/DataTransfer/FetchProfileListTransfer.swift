//
//  FetchProfileListTransfer.swift
//  NetworkModule
//
//  Created by KTH on 2023/02/18.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import DataMappingModule
import DomainModule
import Foundation
import Utility

public extension FetchProfileListResponseDTO {
    func toDomain() -> ProfileListEntity {
        ProfileListEntity(
            type: type ?? "unknown",
            version: version,
            isSelected: false
        )
    }
}
