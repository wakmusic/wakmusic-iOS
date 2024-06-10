//
//  NoticeAPI.swift
//  APIKit
//
//  Created by KTH on 2023/04/04.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import BaseDomain
import ErrorModule
import Foundation
import Moya
import NoticeDomainInterface

public enum NoticeAPI {
    case fetchNotice(type: NoticeType)
    case fetchNoticeCategories
}

extension NoticeAPI: WMAPI {
    public var domain: WMDomain {
        switch self {
        case .fetchNotice,
             .fetchNoticeCategories:
            return .notice
        }
    }

    public var urlPath: String {
        switch self {
        case let .fetchNotice(type):
            return "/\(type.rawValue)"
        case .fetchNoticeCategories:
            return "/categories"
        }
    }

    public var method: Moya.Method {
        switch self {
        case .fetchNotice,
             .fetchNoticeCategories:
            return .get
        }
    }

    public var task: Moya.Task {
        switch self {
        case let .fetchNotice(type):
            return .requestParameters(
                parameters: [
                    "os": "ios",
                    "version": Bundle.main
                        .object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? ""
                ],
                encoding: URLEncoding.queryString
            )
        case .fetchNoticeCategories:
            return .requestPlain
        }
    }

    public var jwtTokenType: JwtTokenType {
        return .none
    }

    public var errorMap: [Int: WMError] {
        switch self {
        default:
            return [
                400: .badRequest,
                401: .tokenExpired,
                404: .notFound,
                429: .tooManyRequest,
                500: .internalServerError
            ]
        }
    }
}
