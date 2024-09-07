import BaseDomain
import ErrorModule
import Foundation
import Moya
import SongsDomainInterface

public enum SongsAPI {
    case fetchSong(id: String)
    case fetchLyrics(id: String)
    case fetchCredits(id: String)
    case fetchNewSongs(type: NewSongGroupType, page: Int, limit: Int)
    case fetchNewSongsPlaylist(type: NewSongGroupType)
}

extension SongsAPI: WMAPI {
    public var domain: WMDomain {
        return .songs
    }

    public var urlPath: String {
        switch self {
        case let .fetchSong(id):
            return "/\(id)"
        case let .fetchLyrics(id):
            return "/\(id)/lyrics"
        case let .fetchCredits(id):
            return "/\(id)/credits"
        case let .fetchNewSongs(type, _, _):
            return "/latest/\(type.apiKey)"
        case let .fetchNewSongsPlaylist(type):
            return "/latest/\(type.apiKey)/playlist"
        }
    }

    public var method: Moya.Method {
        return .get
    }

    public var task: Moya.Task {
        switch self {
        case .fetchSong, .fetchLyrics, .fetchCredits,
             .fetchNewSongsPlaylist:
            return .requestPlain

        case let .fetchNewSongs(_, page, limit):
            return .requestParameters(
                parameters: [
                    "limit": limit,
                    "page": page
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
