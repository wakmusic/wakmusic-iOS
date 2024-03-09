//
//  ArtistListResponseDTO.swift
//  DataMappingModule
//
//  Created by KTH on 2023/02/01.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation
import AuthDomainInterface

public struct AuthLoginResponseDTO: Decodable, Equatable {
    public let token: String

    public static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.token == rhs.token
    }
}

public extension AuthLoginResponseDTO {
    func toDomain() -> AuthLoginEntity {
        AuthLoginEntity(
            token: token
        )
    }
}
