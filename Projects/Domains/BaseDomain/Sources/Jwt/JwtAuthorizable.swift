//
//  JwtAuthorizable.swift
//  BaseDomain
//
//  Created by KTH on 2024/03/04.
//  Copyright © 2024 yongbeomkwak. All rights reserved.
//

import Moya

public enum JwtTokenType: String {
    case accessToken
    case refreshToken
    case none

    var headerKey: String {
        switch self {
        case .accessToken, .refreshToken:
            return "Authorization"
        default:
            return ""
        }
    }
}

public protocol JwtAuthorizable {
    var jwtTokenType: JwtTokenType { get }
}
