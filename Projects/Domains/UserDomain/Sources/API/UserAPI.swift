import ErrorModule
import Foundation
import KeychainModule
import Moya
import BaseDomain

public enum UserAPI {
    case fetchProfileList
    case setProfile(image: String)
    case setUserName(name: String)
    case fetchPlayList
    case fetchFavoriteSongs
    case editFavoriteSongsOrder(ids: [String])
    case editPlayListOrder(ids: [String])
    case deletePlayList(ids: [String])
    case deleteFavoriteList(ids: [String])
    case fetchUserInfo
    case withdrawUserInfo
}

public struct RequsetProfileModel: Encodable {
    var type: String
}

public struct RequsetUserNameModel: Encodable {
    var name: String
}

public struct RequsetEditFavoriteSongs: Encodable {
    var songIds: [String]
}

public struct RequsetEditPlayList: Encodable {
    var playlistKeys: [String]
}

public struct RequsetDeletePlayList: Encodable {
    var playlistKeys: [String]
}

public struct RequestDeleteFavoriteList: Encodable {
    var songIds: [String]
}

extension UserAPI: WMAPI {
    public var domain: WMDomain {
        .user
    }

    public var urlPath: String {
        switch self {
        case .fetchProfileList:
            return "/profile/list"
        case .setProfile:
            return "/profile"
        case .setUserName:
            return "/name"
        case .fetchPlayList:
            return "/playlists"
        case .fetchFavoriteSongs:
            return "/likes"
        case .editFavoriteSongsOrder:
            return "/likes"
        case .deleteFavoriteList:
            return "/likes/delete"
        case .editPlayListOrder:
            return "/playlists"
        case .deletePlayList:
            return "/playlists/delete"

        case .fetchUserInfo:
            return "/profile"

        case .withdrawUserInfo:
            return "/remove"
        }
    }

    public var method: Moya.Method {
        switch self {
        case .fetchProfileList, .fetchPlayList, .fetchFavoriteSongs, .fetchUserInfo:
            return .get
        case .setProfile, .setUserName:
            return .patch
        case .withdrawUserInfo:
            return .delete

        case .editPlayListOrder, .editFavoriteSongsOrder:
            return .put

        case .deletePlayList, .deleteFavoriteList:
            return .post
        }
    }

    public var task: Moya.Task {
        switch self {
        case let .setProfile(type):
            return .requestJSONEncodable(RequsetProfileModel(type: type))
        case let .setUserName(name):
            return .requestJSONEncodable(RequsetUserNameModel(name: name))
        case .fetchProfileList, .fetchPlayList, .fetchFavoriteSongs, .fetchUserInfo, .withdrawUserInfo:
            return .requestPlain
        case let .editFavoriteSongsOrder(ids: ids):
            return .requestJSONEncodable(RequsetEditFavoriteSongs(songIds: ids))
        case let .editPlayListOrder(ids: ids):
            return .requestJSONEncodable(RequsetEditPlayList(playlistKeys: ids))
        case let .deletePlayList(ids):
            return .requestJSONEncodable(RequsetDeletePlayList(playlistKeys: ids))
        case let .deleteFavoriteList(ids):
            return .requestJSONEncodable(RequestDeleteFavoriteList(songIds: ids))
        }
    }

    public var jwtTokenType: JwtTokenType {
        switch self {
        case .fetchProfileList:
            return .none
        default:
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
