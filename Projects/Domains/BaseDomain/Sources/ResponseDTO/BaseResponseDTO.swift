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

#warning("어떤 문제인지 기존 모듈과 충돌함")
/*
 public extension BaseResponseDTO {
 func toDomain() -> BaseEntity {
 return BaseEntity(status: status)
 }
 }
 */
