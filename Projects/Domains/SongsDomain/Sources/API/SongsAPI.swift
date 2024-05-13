import BaseDomain
import ErrorModule
import Foundation
import Moya
import SongsDomainInterface

public enum SongsAPI {
    case fetchSearchSong(keyword: String)
    case fetchLyrics(id: String)
    case fetchCredits(id: String)
    case fetchNewSongs(type: NewSongGroupType, page: Int, limit: Int)
}

extension SongsAPI: WMAPI {
    public var domain: WMDomain {
        return .songs
    }

    public var urlPath: String {
        switch self {
        case .fetchSearchSong:
            return "/search/all"
        case let .fetchLyrics(id):
            return "/\(id)/lyrics"
        case let .fetchCredits(id):
            return "/\(id)/credits"
        case let .fetchNewSongs(type, _, _):
            return "/new/\(type.apiKey)"
        }
    }

    public var method: Moya.Method {
        return .get
    }

    public var task: Moya.Task {
        switch self {
        case let .fetchSearchSong(keyword):
            return .requestParameters(parameters: [
                "sort": "popular", // 기본 인기순으로
                "keyword": keyword
            ], encoding: URLEncoding.queryString)

        case .fetchLyrics, .fetchCredits:
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
