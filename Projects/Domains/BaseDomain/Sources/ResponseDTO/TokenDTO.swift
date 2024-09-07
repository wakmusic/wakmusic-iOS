//
//  TokenDTO.swift
//  BaseDomain
//
//  Created by KTH on 2024/03/04.
//  Copyright © 2024 yongbeomkwak. All rights reserved.
//

import Foundation

struct TokenDTO: Equatable, Decodable {
    let accessToken: String
    let refreshToken: String?
    let expiresIn: Int

    enum DefaultCodingKeys: String, CodingKey {
        case accessToken
        case refreshToken
        case expiresIn
    }

    enum RefreshableCodingKeys: String, CodingKey {
        case token
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DefaultCodingKeys.self)
        let refreshableContainer = try decoder.container(keyedBy: RefreshableCodingKeys.self)

        let accessToken: String
        if let token = try? container.decode(String.self, forKey: .accessToken) {
            accessToken = token
        } else if let token = try? refreshableContainer.decode(String.self, forKey: .token) {
            accessToken = token
        } else {
            throw Error.cannotDecodeAccessToken
        }
        self.accessToken = accessToken
        self.refreshToken = try container.decodeIfPresent(String.self, forKey: .refreshToken)
        self.expiresIn = try container.decode(Int.self, forKey: .expiresIn)
    }

    enum Error: Swift.Error, LocalizedError {
        case cannotDecodeAccessToken

        var errorDescription: String? {
            switch self {
            case .cannotDecodeAccessToken:
                return "Cannot decode access token in data"
            }
        }
    }
}
