import BaseDomain
import ErrorModule
import Foundation
import KeychainModule
import Moya

public enum UserAPI {
    case fetchUserInfo
    case fetchPlayList
    case editPlayListOrder(ids: [String])
    case deletePlayList(ids: [String])
    case fetchFavoriteSongs
    case editFavoriteSongsOrder(ids: [String])
    case deleteFavoriteList(ids: [String])
    case setProfile(image: String)
    case setUserName(name: String)
    case withdrawUserInfo
}

private struct RequsetProfileModel: Encodable {
    var imageName: String
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
        case .fetchUserInfo:
            return "/profile"
        case .fetchPlayList:
            return "/playlists"
        case .editPlayListOrder:
            return "/playlists"
        case .deletePlayList:
            return "/playlists"
        case .fetchFavoriteSongs:
            return "/likes"
        case .editFavoriteSongsOrder:
            return "/likes"
        case .deleteFavoriteList:
            return "/likes"
        case .setProfile:
            return "/profile/image"
        case .setUserName:
            return "/profile/name"
        case .withdrawUserInfo:
            return "/user/delete"
        }
    }

    public var method: Moya.Method {
        switch self {
        case .fetchUserInfo:
            return .get
        case .fetchPlayList:
            return .get
        case .editPlayListOrder:
            return .patch
        case .deletePlayList:
            return .delete
        case .fetchFavoriteSongs:
            return .get
        case .editFavoriteSongsOrder:
            return .patch
        case .deleteFavoriteList:
            return .delete
        case .setProfile:
            return .patch
        case .setUserName:
            return .patch
        case .withdrawUserInfo:
            return .delete
        }
    }

    public var task: Moya.Task {
        switch self {
        
        case .fetchUserInfo:
            return .requestPlain
        case .fetchPlayList:
            return .requestPlain
        case let .editPlayListOrder(ids):
            return .requestJSONEncodable(RequsetEditPlayList(playlistKeys: ids))
        case let .deletePlayList(ids):
            return .requestParameters(
                parameters: [
                    "playlistKeys": ids.joined(separator: ",")
                ],
                encoding: URLEncoding.queryString
            )
        case .fetchFavoriteSongs:
            return .requestPlain
        case let .editFavoriteSongsOrder(ids):
            return .requestJSONEncodable(RequsetEditFavoriteSongs(songIds: ids))
        case let .deleteFavoriteList(ids):
            return .requestParameters(
                parameters: [
                    "songIds": ids.joined(separator: ",")
                ],
                encoding: URLEncoding.queryString
            )
        case let .setProfile(image):
            return .requestJSONEncodable(RequsetProfileModel(imageName: image))
        case let .setUserName(name):
            return .requestJSONEncodable(RequsetUserNameModel(name: name))
        case .withdrawUserInfo:
            return .requestPlain
        }
    }

    public var jwtTokenType: JwtTokenType {
        switch self {
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
