import Moya
import DataMappingModule
import ErrorModule
import Foundation

public enum SongsAPI {
    case fetchSearchSong(type: SearchType, keyword: String)
    case fetchNewSong(type: NewSongGroupType)
    case fetchLyrics(id: String)
    case fetchNewSongs(type: NewSongGroupType, page: Int, limit: Int)
}

extension SongsAPI: WMAPI {
    public var domain: WMDomain {
        return .songs
    }
    
    public var path: String {
        switch self {
        case .fetchNewSongs:
            return "/\(WMDOMAIN_V2_SONGS())" + urlPath
        default:
            return domain.asURLString + urlPath
        }
    }

    public var urlPath: String {
        switch self {
        case .fetchSearchSong:
            return "/search"
        case let .fetchNewSong(type):
            return "/new/\(type.apiKey)"
        case .fetchLyrics(id: let id):
            return "/lyrics/\(id)"
        case let .fetchNewSongs(type, _, _):
            return "/new/\(type.apiKey)"
        }
    }
        
    public var method: Moya.Method {
        return .get
    }
    
    public var task: Moya.Task {
        switch self {
        case let .fetchSearchSong(type,keyword):
            return .requestParameters(parameters: [
                "type": type.rawValue,
                "sort": "popular", //기본 인기순으로
                "keyword": keyword
            ], encoding: URLEncoding.queryString)
            
        case .fetchLyrics, .fetchNewSong:
            return .requestPlain

        case let .fetchNewSongs(_, page, limit):
            return .requestParameters(
                parameters: [
                    "limit": limit,
                    "start": (page == 1) ? 0 : (page - 1) * limit
                ],
                encoding: URLEncoding.queryString
            )
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
