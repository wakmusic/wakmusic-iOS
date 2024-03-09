//
//  NaverUserInfoResponseDTO.swift
//  DataMappingModule
//
//  Created by yongbeomkwak on 2023/02/15.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation

public struct NaverUserInfoResponseDTO: Codable, Equatable {
    public static func == (lhs: NaverUserInfoResponseDTO, rhs: NaverUserInfoResponseDTO) -> Bool {
        lhs.response.id == rhs.response.id
    }

    public let resultcode, message: String
    public let response: Response
}

public extension NaverUserInfoResponseDTO {
    struct Response: Codable {
        public let id, nickname: String
    }
}
