//
//  GoogleGetTokenEntity.swift
//  DomainModule
//
//  Created by 김대희 on 2023/04/01.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation

public struct GoogleGetTokenEntity: Codable {
    public init(
        accessToken: String,
        expiresIn: Int,
        tokenType: String,
        scope: String,
        refreshToken: String
    ) {
        self.accessToken = accessToken
        self.expiresIn = expiresIn
        self.tokenType = tokenType
        self.scope = scope
        self.refreshToken = refreshToken
    }

    public let accessToken: String
    public let expiresIn: Int
    public let tokenType: String
    public let scope: String
    public let refreshToken: String

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case expiresIn = "expires_in"
        case tokenType = "token_type"
        case scope
        case refreshToken = "refresh_token"
    }
}
