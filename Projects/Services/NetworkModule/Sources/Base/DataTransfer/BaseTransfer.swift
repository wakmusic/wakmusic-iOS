//
//  BaseTransfer.swift
//  NetworkModule
//
//  Created by KTH on 2023/02/18.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation
import DataMappingModule
import DomainModule
import Utility

public extension BaseResponseDTO {
    func toDomain() -> BaseEntity {
        BaseEntity(
            status: status
        )
    }
}
