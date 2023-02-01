//
//  ArtistAPI.swift
//  APIKit
//
//  Created by KTH on 2023/02/01.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Moya
import DataMappingModule
import ErrorModule
import Foundation

public enum ArtistAPI {
    case fetchArtistList
    case fetchArtistSongList(id: String, sort: ArtistSortType)
    case fetchArtistImage(type: ArtistImageType, id: String)
}

extension ArtistAPI: WMAPI {
    public var domain: WMDomain {
        switch self{
        case .fetchArtistList:
            return .artist
        case .fetchArtistSongList:
            return .artist
        case .fetchArtistImage:
            return .common
        }
    }
    
    public var urlPath: String {
        switch self {
        case .fetchArtistList:
            return "/list"
        case .fetchArtistSongList:
            return "/albums"
        case let .fetchArtistImage(type, id):
            let ext: String = (type == .big) ? ".jpg" : ".png"
            return "/static/artist/\(type.rawValue)/\(id)\(ext)"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .fetchArtistList,
             .fetchArtistSongList,
             .fetchArtistImage:
            return .get
        }
    }
    
    public var task: Moya.Task {
        switch self {
        case let .fetchArtistSongList(id, sort):
            return .requestParameters(parameters: [
                "id": id,
                "sort": sort.rawValue
            ], encoding: URLEncoding.queryString)
        case .fetchArtistList:
            return .requestPlain
        case .fetchArtistImage:
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
