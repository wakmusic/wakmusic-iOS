//
//  NoticeAPI.swift
//  APIKit
//
//  Created by KTH on 2023/04/04.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation
import Moya
import DataMappingModule
import ErrorModule

public enum NoticeAPI {
    case fetchAllNoticeList
    case fetchLatestNoticeList
    case fetchNoticeCategories
}

extension NoticeAPI: WMAPI {
    public var domain: WMDomain {
        switch self{
        case .fetchAllNoticeList,
             .fetchLatestNoticeList,
             .fetchNoticeCategories:
            return .notice
        }
    }
    
    public var urlPath: String {
        switch self {
        case .fetchAllNoticeList:
            return ""
        case .fetchLatestNoticeList:
            return "/latest"
        case .fetchNoticeCategories:
            return "/categories"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .fetchAllNoticeList,
             .fetchLatestNoticeList,
             .fetchNoticeCategories:
            return .get
        }
    }
    
    public var task: Moya.Task {
        switch self {
        case .fetchAllNoticeList,
             .fetchLatestNoticeList,
             .fetchNoticeCategories:
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
