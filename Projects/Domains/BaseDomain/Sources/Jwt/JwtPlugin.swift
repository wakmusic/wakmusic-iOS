//
//  JwtPlugin.swift
//  BaseDomain
//
//  Created by KTH on 2024/03/04.
//  Copyright © 2024 yongbeomkwak. All rights reserved.
//

import Foundation
import KeychainModule
import Moya

public struct JwtPlugin: PluginType {
    private let keychain: any Keychain

    public init(keychain: any Keychain) {
        self.keychain = keychain
    }

    public func prepare(
        _ request: URLRequest,
        target: TargetType
    ) -> URLRequest {
        guard let jwtTokenType = (target as? JwtAuthorizable)?.jwtTokenType,
              jwtTokenType != .none,
              let keychainType = jwtTokenTypeToKeychainType(jwtTokenType: jwtTokenType),
              let token = getToken(type: keychainType)
        else { return request }
        var req = request

        req.addValue(token, forHTTPHeaderField: jwtTokenType.headerKey)
        return req
    }

    public func didReceive(
        _ result: Result<Response, MoyaError>,
        target: TargetType
    ) {
        switch result {
        case let .success(res):
            if let new = try? res.map(TokenDTO.self) {
                saveToken(token: new)
            }
        default:
            break
        }
    }
}

private extension JwtPlugin {
    func jwtTokenTypeToKeychainType(jwtTokenType: JwtTokenType) -> KeychainType? {
        switch jwtTokenType {
        case .accessToken:
            return .accessToken
        case .refreshToken:
            return .refreshToken
        default:
            return nil
        }
    }

    func getToken(type: KeychainType) -> String? {
        let token = keychain.load(type: type)

        guard !token.isEmpty else { return nil }

        switch type {
        case .accessToken:
            return "bearer \(token)"

        case .refreshToken:
            return "bearer \(token)"
        default:
            return ""
        }
    }

    func saveToken(token: TokenDTO) {
        keychain.save(type: .accessToken, value: token.accessToken)
        if let refreshToken = token.refreshToken {
            keychain.save(type: .refreshToken, value: refreshToken)
        }
        keychain.save(type: .accessExpiresIn, value: "\(token.expiresIn)")
    }
}
