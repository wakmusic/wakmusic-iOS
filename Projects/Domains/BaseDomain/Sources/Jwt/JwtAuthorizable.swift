//
//  JwtAuthorizable.swift
//  BaseDomain
//
//  Created by KTH on 2024/03/04.
//  Copyright © 2024 yongbeomkwak. All rights reserved.
//

import Moya

public enum JwtTokenType: String {
    case accessToken = "Authorization"
    case refreshToken = "refresh-token"
    case none
}

public protocol JwtAuthorizable {
    var jwtTokenType: JwtTokenType { get }
}
