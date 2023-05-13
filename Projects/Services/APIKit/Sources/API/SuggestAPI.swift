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
    case reportBug(userID: String, nickname: String, attaches: [String], content: String)
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
             .inquiryWeeklyChart:
            return URL(string: WAKENTER_BASE_URL())!
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
            let version = ProcessInfo.processInfo.operatingSystemVersion
            let versionString = "\(version.majorVersion).\(version.minorVersion).\(version.patchVersion)"
            let osName: String = {
                #if os(iOS)
                #if targetEnvironment(macCatalyst)
                return "macOS(Catalyst)"
                #else
                return "iOS"
                #endif
                #elseif os(watchOS)
                return "watchOS"
                #elseif os(tvOS)
                return "tvOS"
                #elseif os(macOS)
                return "macOS"
                #elseif os(Linux)
                return "Linux"
                #elseif os(Windows)
                return "Windows"
                #else
                return "Unknown"
                #endif
            }()
            var parameters: [String: Any] = ["userId": userID,
                                             "detailContent": content,
                                             "osVersion": "\(osName) \(versionString)",
                                             "deviceModel": Device().modelName]
            if !nickname.isEmpty {
                parameters["nickname"] = nickname
            }
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
