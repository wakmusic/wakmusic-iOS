import Moya
import DataMappingModule
import ErrorModule
import Foundation
import KeychainModule

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
}

public struct RequsetProfileModel:Encodable {
    var image:String
}

public struct RequsetUserNameModel:Encodable {
    var username:String
}

public struct RequsetEditFavoriteSongs:Encodable {
    var songs:[String]
}

public struct RequsetEditPlayList:Encodable {
    var playlists:[String]
}

public struct RequsetDeletePlayList: Encodable {
    var playlists:[String]
}

public struct RequestDeleteFavoriteList: Encodable {
    var songs: [String]
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
            return "/profile/set"
        case .setUserName:
            return "/username"
        case .fetchPlayList:
            return "/playlists"
        case .fetchFavoriteSongs:
            return "/likes"
        case .editFavoriteSongsOrder:
            return "/likes/edit"
        case .deleteFavoriteList:
            return "/likes/delete"
        case .editPlayListOrder:
            return "/playlists/edit"
        case .deletePlayList:
            return "/playlists/delete"
        }
    }
        
    public var method: Moya.Method {
        switch self {
        case .setProfile, .setUserName:
            return .post
        case .fetchProfileList, .fetchPlayList,.fetchFavoriteSongs:
            return .get
        case .editFavoriteSongsOrder,.editPlayListOrder:
            return .patch
        case .deletePlayList, .deleteFavoriteList:
            return .delete
        }
    }
    
    public var task: Moya.Task {
        switch self {
        case let .setProfile(image):
            return .requestJSONEncodable(RequsetProfileModel(image: image))
        case let .setUserName(name):
            return .requestJSONEncodable(RequsetUserNameModel(username: name))
        case .fetchProfileList, .fetchPlayList,.fetchFavoriteSongs:
            return .requestPlain
        case .editFavoriteSongsOrder(ids: let ids):
            return .requestJSONEncodable(RequsetEditFavoriteSongs(songs: ids))
        case .editPlayListOrder(ids: let ids):
            return .requestJSONEncodable(RequsetEditPlayList(playlists: ids))
        case let .deletePlayList(ids):
            return .requestJSONEncodable(RequsetDeletePlayList(playlists: ids))
        case let .deleteFavoriteList(ids):
            return .requestJSONEncodable(RequestDeleteFavoriteList(songs: ids))
        }
    }
        
    public var jwtTokenType: JwtTokenType {
        switch self {
        case .fetchProfileList:
            return .none
        default :
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
