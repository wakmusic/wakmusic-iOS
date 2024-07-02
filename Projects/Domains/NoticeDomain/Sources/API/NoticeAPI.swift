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
    case fetchNoticeCategories
    case fetchNoticePopup
    case fetchNoticeAll
    case fetchNoticeIDList
}

extension NoticeAPI: WMAPI {
    public var domain: WMDomain {
        return .notice
    }

    public var urlPath: String {
        switch self {
        case .fetchNoticeCategories:
            return "/categories"
        case .fetchNoticePopup:
            return "/popup"
        case .fetchNoticeAll:
            return "/all"
        case .fetchNoticeIDList:
            return "/ids"
        }
    }

    public var method: Moya.Method {
        switch self {
        case .fetchNoticeCategories:
            return .get
        case .fetchNoticePopup:
            return .get
        case .fetchNoticeAll:
            return .get
        case .fetchNoticeIDList:
            return .get
        }
    }

    public var task: Moya.Task {
        switch self {
        case .fetchNoticeCategories:
            return .requestPlain
        case .fetchNoticePopup:
            return .requestPlain
        case .fetchNoticeAll:
            return .requestPlain
        case .fetchNoticeIDList:
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
