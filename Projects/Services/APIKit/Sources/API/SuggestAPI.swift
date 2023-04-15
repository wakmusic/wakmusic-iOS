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

public enum SuggestAPI {
    case reportBug(userID: String, nickname: String, attaches: [Data], content: String)
    case suggestFunction(type: SuggestPlatformType, userID: String, content: String)
    case modifySong(type: SuggestSongModifyType, userID: String, artist: String, songTitle: String, youtubeLink: String, content: String)
    case inquiryWeeklyChart(userID: String, content: String)
}

extension SuggestAPI: WMAPI {
    public var baseURL: URL {
        switch self {
        case .reportBug,
             .suggestFunction,
             .modifySong,
             .inquiryWeeklyChart: //추후 baseURL 수정 예정
            return URL(string: "http://ec2-15-164-250-124.ap-northeast-2.compute.amazonaws.com:4000")!
        }
    }
        
    public var domain: WMDomain {
        switch self {
        case .reportBug,
             .suggestFunction,
             .modifySong,
             .inquiryWeeklyChart:
            return .suggest
        }
    }

    public var urlPath: String {
        switch self {
        case .reportBug:
            return "/bug"
        case .suggestFunction:
            return "/feature"
        case .modifySong:
            return "/music"
        case .inquiryWeeklyChart:
            return "/weekly"
        }
    }

    public var method: Moya.Method {
        switch self {
        case .reportBug, .suggestFunction, .modifySong, .inquiryWeeklyChart:
            return .put
        }
    }
    
    public var headers: [String : String]? {
        switch self {
        case .reportBug, .suggestFunction, .modifySong, .inquiryWeeklyChart:
            return ["Content-Type": "application/json"]
        }
    }

    public var task: Moya.Task {
        switch self {
        case let .reportBug(userID, nickname, attaches, content):
            var parameters: [String: Any] = ["userId": userID,
                                             "nickname": nickname,
                                             "detailContent": content]
            if !attaches.isEmpty {
                parameters["attachs"] = attaches
            }
            return .requestParameters(parameters: parameters,
                                      encoding: JSONEncoding.default)

        case let .suggestFunction(type, userID, content):
            return .requestParameters(parameters: ["userId": userID,
                                                   "platform": type.rawValue,
                                                   "detailContent": content],
                                      encoding: JSONEncoding.default)

        case let .modifySong(type, userID, artist, songTitle, youtubeLink, content):
            return .requestParameters(parameters: ["userId": userID,
                                                   "type": type.rawValue,
                                                   "artist": artist,
                                                   "musicTitle": songTitle,
                                                   "youtubeLink": youtubeLink,
                                                   "detailContent": content],
                                      encoding: JSONEncoding.default)
            
        case let .inquiryWeeklyChart(userID, content):
            return .requestParameters(parameters: ["userId": userID,
                                                   "detailContent": content],
                                      encoding: JSONEncoding.default)
        }
    }

    public var jwtTokenType: JwtTokenType {
        switch self {
        case .reportBug, .suggestFunction, .modifySong, .inquiryWeeklyChart:
            return .none
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
