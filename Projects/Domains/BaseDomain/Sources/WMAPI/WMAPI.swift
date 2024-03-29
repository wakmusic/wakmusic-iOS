//
//  WMAPI.swift
//  BaseDomain
//
//  Created by KTH on 2024/03/04.
//  Copyright © 2024 yongbeomkwak. All rights reserved.
//

import ErrorModule
import Foundation
import KeychainModule
import Moya
import Utility

public protocol WMAPI: TargetType, JwtAuthorizable {
    var domain: WMDomain { get }
    var urlPath: String { get }
    var errorMap: [Int: WMError] { get }
}

public extension WMAPI {
    var baseURL: URL {
        URL(string: BASE_URL())!
    }

    var path: String {
        domain.asURLString + urlPath
    }

    var headers: [String: String]? {
        ["Content-Type": "application/json"]
    }

    var validationType: ValidationType {
        return .successCodes
    }
}

public enum WMDomain: String {
    case auth
    case charts
    case songs
    case artist
    case user
    case playlist
    case like
    case naver
    case faq
    case notice
    case app
}

extension WMDomain {
    var asURLString: String {
        "/\(self.asDomainString)"
    }
}

extension WMDomain {
    var asDomainString: String {
        switch self {
        case .auth:
            return WMDOMAIN_AUTH()
        case .charts:
            return WMDOMAIN_CHARTS()
        case .songs:
            return WMDOMAIN_SONGS()
        case .artist:
            return WMDOMAIN_ARTIST()
        case .user:
            return WMDOMAIN_USER()
        case .playlist:
            return WMDOMAIN_PLAYLIST()
        case .like:
            return WMDOMAIN_LIKE()
        case .naver:
            return "/v1/nid/me"
        case .faq:
            return WMDOMAIN_QNA()
        case .notice:
            return WMDOMAIN_NOTICE()
        case .app:
            return WMDOMAIN_APP()
        }
    }
}
