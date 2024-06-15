import BaseDomain
import BaseDomainInterface
import ErrorModule
import Foundation
import KeychainModule
import Moya
import PlayListDomainInterface
import SearchDomainInterface
import SongsDomainInterface

public struct SearchSongRequest: Encodable {
    let order: String
    let filter: String
    let text: String
    let page: Int
    let limit: Int
}

public struct SearchPlaylistRequest: Encodable {
    let order: String
    let text: String
    let page: Int
    let limit: Int
}

public enum SearchAPI {
    case fetchPlaylists(order: SortType, text: String, page: Int, limit: Int)
    case fetchSongs(order: SortType, filter: FilterType, text: String, page: Int, limit: Int)
}

extension SearchAPI: WMAPI {
    public var domain: WMDomain {
        .search
    }

    public var urlPath: String {
        switch self {
        case .fetchPlaylists:
            return "/playlists"
        case .fetchSongs:
            return "/songs"
        }
    }

    public var method: Moya.Method {
        return .get
    }

    public var task: Moya.Task {
        switch self {
        case let .fetchPlaylists(order: order, text: text, page: page, limit: limit):
            return .requestJSONEncodable(SearchPlaylistRequest(
                order: order.rawValue,
                text: text,
                page: page,
                limit: limit
            ))
        case let .fetchSongs(order: order, filter: filter, text: text, page: page, limit: limit):
            return .requestJSONEncodable(SearchSongRequest(
                order: order.rawValue,
                filter: filter.rawValue,
                text: text,
                page: page,
                limit: limit
            ))
        }
    }

    public var headers: [String: String]? {
        switch self {
        default:
            return ["Content-Type": "application/json"]
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
                409: .conflict,
                429: .tooManyRequest,
                500: .internalServerError
            ]
        }
    }
}
