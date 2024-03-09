//
//  NaverUserInfoResponseDTO.swift
//  DataMappingModule
//
//  Created by yongbeomkwak on 2023/02/15.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation
import AuthDomainInterface

public struct NaverUserInfoResponseDTO: Decodable, Equatable {
    public let resultcode, message: String
    public let response: Response

    public static func == (lhs: NaverUserInfoResponseDTO, rhs: NaverUserInfoResponseDTO) -> Bool {
        lhs.response.id == rhs.response.id
    }
}

public extension NaverUserInfoResponseDTO {
    struct Response: Codable {
        public let id, nickname: String
    }
}

public extension NaverUserInfoResponseDTO {
    func toDomain() -> NaverUserInfoEntity {
        NaverUserInfoEntity(
            resultcode: resultcode,
            message: message,
            id: response.id,
            nickname: response.nickname
        )
    }
}
