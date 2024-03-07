//
//  BaseResponseDTO.swift
//  BaseDomain
//
//  Created by KTH on 2024/03/04.
//  Copyright © 2024 yongbeomkwak. All rights reserved.
//

import Foundation

public struct BaseResponseDTO: Codable {
    public let status: Int
}

public extension BaseResponseDTO {
    func toDomain() -> BaseEntity {
        BaseEntity(
            status: status
        )
    }
}
