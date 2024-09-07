import BaseDomain
import ErrorModule
import Foundation
import KeychainModule
import Moya

public enum UserAPI {
    case fetchUserInfo
    case fetchPlaylist
    case editPlaylistOrder(ids: [String])
    case deletePlaylist(ids: [String])
    case fetchFavoriteSongs
    case editFavoriteSongsOrder(ids: [String])
    case deleteFavoriteList(ids: [String])
    case setProfile(image: String)
    case setUserName(name: String)
    case withdrawUserInfo
    case fetchFruitList
    case fetchFruitDrawStatus
    case drawFruit
}

extension UserAPI: WMAPI {
    public var domain: WMDomain {
        .user
    }

    public var urlPath: String {
        switch self {
        case .fetchUserInfo:
            return "/profile"
        case .fetchPlaylist:
            return "/playlists"
        case .editPlaylistOrder:
            return "/playlists"
        case .deletePlaylist:
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
            return "/delete"
        case .fetchFruitList:
            return "/fruit/list"
        case .fetchFruitDrawStatus:
            return "/fruit/status"
        case .drawFruit:
            return "/fruit/draw"
        }
    }

    public var method: Moya.Method {
        switch self {
        case .fetchUserInfo:
            return .get
        case .fetchPlaylist:
            return .get
        case .editPlaylistOrder:
            return .patch
        case .deletePlaylist:
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
        case .fetchFruitList:
            return .get
        case .fetchFruitDrawStatus:
            return .get
        case .drawFruit:
            return .post
        }
    }

    public var task: Moya.Task {
        switch self {
        case .fetchUserInfo:
            return .requestPlain
        case .fetchPlaylist:
            return .requestPlain
        case let .editPlaylistOrder(ids):
            return .requestJSONEncodable(EditPlaylistOrderRequestDTO(playlistKeys: ids))
        case let .deletePlaylist(ids):
            return .requestParameters(
                parameters: [
                    "playlistKeys": ids.joined(separator: ",")
                ],
                encoding: URLEncoding.queryString
            )
        case .fetchFavoriteSongs:
            return .requestPlain
        case let .editFavoriteSongsOrder(ids):
            return .requestJSONEncodable(EditFavoriteSongsOrderRequestDTO(songIds: ids))
        case let .deleteFavoriteList(ids):
            return .requestParameters(
                parameters: [
                    "songIds": ids.joined(separator: ",")
                ],
                encoding: URLEncoding.queryString
            )
        case let .setProfile(image):
            return .requestJSONEncodable(SetProfileRequestDTO(imageName: image))
        case let .setUserName(name):
            return .requestJSONEncodable(SetUserNameRequestDTO(name: name))
        case .withdrawUserInfo:
            return .requestPlain
        case .fetchFruitList:
            return .requestPlain
        case .fetchFruitDrawStatus:
            return .requestPlain
        case .drawFruit:
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
                403: .forbidden,
                404: .notFound,
                409: .conflict,
                429: .tooManyRequest,
                500: .internalServerError
            ]
        }
    }
}
