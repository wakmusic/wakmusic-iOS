//
//  SuggestAPI.swift
//  APIKit
//
//  Created by KTH on 2023/04/09.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Moya
import DataMappingModule
import ErrorModule
import Foundation
import KeychainModule
import Utility

public enum SuggestAPI {
    case bug(attaches: [Data] = [], content: String)
    case function(type: SuggestPlatformType, content: String)
    case weeklyChart(content: String)
    case song(type: SuggestSongAddType, artist: String, songTitle: String, youtubeLink: String, content: String)
}

extension SuggestAPI: WMAPI {
    public var baseURL: URL {
        switch self {
        case .bug, .function, .weeklyChart, .song: //추후 baseURL 수정 예정
            return URL(string: "http://ec2-15-164-250-124.ap-northeast-2.compute.amazonaws.com:4000")!
        }
    }
        
    public var domain: WMDomain {
        switch self {
        case .bug, .function, .weeklyChart, .song:
            return .suggest
        }
    }

    public var urlPath: String {
        switch self {
        case .bug:
            return "/bug"
        case .function:
            return "/feature"
        case .weeklyChart:
            return "/weekly"
        case .song:
            return "/music"
        }
    }

    public var method: Moya.Method {
        switch self {
        case .bug, .function, .weeklyChart, .song:
            return .put
        }
    }
    
    public var headers: [String : String]? {
        switch self {
        case .bug, .function, .weeklyChart, .song:
            return ["Content-Type": "application/json"]
        }
    }

    public var task: Moya.Task {
        let userID: String = AES256.decrypt(encoded: Utility.PreferenceManager.userInfo?.ID ?? "")
        let nickname: String = AES256.decrypt(encoded: Utility.PreferenceManager.userInfo?.displayName ?? "")

        switch self {
        case let .bug(attaches, content):
            var parameters: [String: Any] = ["userId": userID,
                                             "nickname": nickname,
                                             "detailContent": content]
            if !attaches.isEmpty {
                parameters["attachs"] = attaches
            }
            return .requestParameters(parameters: parameters,
                                      encoding: JSONEncoding.default)

        case let .function(type, content):
            return .requestParameters(parameters: ["userId": userID,
                                                   "platform": type.rawValue,
                                                   "detailContent": content],
                                      encoding: JSONEncoding.default)

        case let .weeklyChart(content):
            return .requestParameters(parameters: ["userId": userID,
                                                   "detailContent": content],
                                      encoding: JSONEncoding.default)

        case let .song(type, artist, songTitle, youtubeLink, content):
            return .requestParameters(parameters: ["userId": userID,
                                                   "type": type.rawValue,
                                                   "artist": artist,
                                                   "musicTitle": songTitle,
                                                   "youtubeLink": youtubeLink,
                                                   "detailContent": content],
                                      encoding: JSONEncoding.default)
        }
    }

    public var jwtTokenType: JwtTokenType {
        switch self {
        case .bug, .function, .weeklyChart, .song:
            return .accessToken
        }
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
