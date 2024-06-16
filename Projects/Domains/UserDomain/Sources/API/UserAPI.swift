import BaseDomain
import ErrorModule
import Foundation
import KeychainModule
import Moya

public enum UserAPI {
    case fetchProfileList
    case fetchUserInfo
    case fetchPlayList
    case editPlayListOrder(ids: [String])
    case deletePlayList(ids: [String])
    case fetchFavoriteSongs
    case editFavoriteSongsOrder(ids: [String])
    case deleteFavoriteList(ids: [String])
    #warning("엔드포인트 구현되면 추가 필요")
    case setProfile(image: String)
    case setUserName(name: String)
    case withdrawUserInfo
}

private struct RequsetProfileModel: Encodable {
    var type: String
}

private struct RequsetUserNameModel: Encodable {
    var name: String
}

private struct RequsetEditFavoriteSongs: Encodable {
    var songIds: [String]
}

private struct RequsetEditPlayList: Encodable {
    var playlistKeys: [String]
}

extension UserAPI: WMAPI {
    public var domain: WMDomain {
        .user
    }

    public var urlPath: String {
        switch self {
        case .fetchProfileList:
            return "/profile/list"
        case .fetchUserInfo:
            return "/profile"
        case .fetchPlayList:
            return "/playlists"
        case .editPlayListOrder(let ids):
            return "/playlists"
        case .deletePlayList(let ids):
            return "/playlists"
        case .fetchFavoriteSongs:
            return "/likes"
        case .editFavoriteSongsOrder(let ids):
            return "/likes"
        case .deleteFavoriteList(let ids):
            return "/likes"
        case .setProfile(let image):
            return ""
        case .setUserName(let name):
            return ""
        case .withdrawUserInfo:
            return ""
        }
    }

    public var method: Moya.Method {
        switch self {
        case .fetchProfileList:
            return .get
        case .fetchUserInfo:
            return .get
        case .fetchPlayList:
            return .get
        case .editPlayListOrder(let ids):
            return .patch
        case .deletePlayList(let ids):
            return .delete
        case .fetchFavoriteSongs:
            return .get
        case .editFavoriteSongsOrder(let ids):
            return .patch
        case .deleteFavoriteList(let ids):
            return .delete
        case .setProfile(let image):
            return .patch
        case .setUserName(let name):
            return .patch
        case .withdrawUserInfo:
            return .delete
        }
    }

    public var task: Moya.Task {
        switch self {
        case .fetchProfileList:
            return .requestPlain
        case .fetchUserInfo:
            return .requestPlain
        case .fetchPlayList:
            return .requestPlain
        case .editPlayListOrder(let ids):
            return .requestJSONEncodable(RequsetEditPlayList(playlistKeys: ids))
        case .deletePlayList(let ids):
            return .requestParameters(
                parameters: [
                    "playlistKeys": ids.joined(separator: ",")
                ],
                encoding: URLEncoding.queryString
            )
        case .fetchFavoriteSongs:
            return .requestPlain
        case .editFavoriteSongsOrder(let ids):
            return .requestJSONEncodable(RequsetEditFavoriteSongs(songIds: ids))
        case .deleteFavoriteList(let ids):
            return .requestParameters(
                parameters: [
                    "songIds": ids.joined(separator: ",")
                ],
                encoding: URLEncoding.queryString
            )
        case .setProfile(let image):
            return .requestJSONEncodable(RequsetProfileModel(type: image))
        case .setUserName(let name):
            return .requestJSONEncodable(RequsetUserNameModel(name: name))
        case .withdrawUserInfo:
            return .requestPlain
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
