import ArtistDomainInterface
import BaseDomain
import ErrorModule
import Foundation
import Moya

public enum ArtistAPI {
    case fetchArtistList
    case fetchArtistDetail(id: String)
    case fetchArtistSongList(id: String, sort: ArtistSongSortType, page: Int)
    case fetchSubscriptionStatus(id: String)
    case subscriptionArtist(id: String, on: Bool)
    case findArtistID(name: String)
}

extension ArtistAPI: WMAPI {
    public var domain: WMDomain {
        return .artist
    }

    public var urlPath: String {
        switch self {
        case .fetchArtistList:
            return "/list"
        case let .fetchArtistDetail(id):
            return "/\(id)"
        case let .fetchArtistSongList(id, _, _):
            return "/\(id)/songs"
        case let .fetchSubscriptionStatus(id):
            return "/\(id)/subscription"
        case let .subscriptionArtist(id, _):
            return "/\(id)/subscription"
        case let .findArtistID(name):
            return "/find"
        }
    }

    public var method: Moya.Method {
        switch self {
        case .fetchArtistList,
             .fetchArtistDetail,
             .fetchArtistSongList,
             .fetchSubscriptionStatus,
             .findArtistID:
            return .get
        case let .subscriptionArtist(_, on):
            return on ? .post : .delete
        }
    }

    public var task: Moya.Task {
        switch self {
        case .fetchArtistList,
             .fetchArtistDetail,
             .fetchSubscriptionStatus,
             .subscriptionArtist:
            return .requestPlain
        case let .fetchArtistSongList(_, sort, page):
            return .requestParameters(
                parameters: [
                    "type": sort.rawValue,
                    "page": page
                ],
                encoding: URLEncoding.queryString
            )
        case let .findArtistID(name):
            return .requestParameters(
                parameters: [
                    "name": name
                ],
                encoding: URLEncoding.queryString
            )
        }
    }

    public var jwtTokenType: JwtTokenType {
        switch self {
        case .fetchArtistList, .fetchArtistDetail, .fetchArtistSongList, .findArtistID:
            return .none
        case .fetchSubscriptionStatus, .subscriptionArtist:
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
