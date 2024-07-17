//
//  AppAPI.swift
//  AppDomain
//
//  Created by KTH on 2024/03/04.
//  Copyright © 2024 yongbeomkwak. All rights reserved.
//

import BaseDomain
import ErrorModule
import Foundation
import Moya

public enum AppAPI {
    case fetchAppCheck
}

extension AppAPI: WMAPI {
    public var domain: WMDomain {
        return WMDomain.app
    }

    public var urlPath: String {
        switch self {
        case .fetchAppCheck:
            return "/check"
        }
    }

    public var method: Moya.Method {
        return .get
    }

    public var task: Moya.Task {
        switch self {
        case .fetchAppCheck:
            return .requestPlain
        }
    }

    public var jwtTokenType: JwtTokenType {
        return .none
    }

    public var baseInfoTypes: [BaseInfoType] {
        return [.os, .appVersion]
    }

    public var errorMap: [Int: WMError] {
        switch self {
        default:
            return [
                400: .badRequest,
                401: .tokenExpired,
                404: .notFound,
                429: .tooManyRequest,
                500: .internalServerError,
                502: .internalServerError,
                521: .internalServerError,
                1009: .offline
            ]
        }
    }
}
