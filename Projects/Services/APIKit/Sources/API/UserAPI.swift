import Moya
import DataMappingModule
import ErrorModule
import Foundation
import KeychainModule

public enum UserAPI {
    case fetchProfileList
    case setProfile(image: String)
    case setUserName(name: String)
    case fetchSubPlayList
    case fetchFavoriteSongs
    case editFavoriteSongsOrder(ids:[String])
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
        case .fetchSubPlayList:
            return "/playlists"
        case .fetchFavoriteSongs:
            return "/likes"
        case .editFavoriteSongsOrder:
            return "/likes/edit"
        }
    }
        
    public var method: Moya.Method {
        switch self {
        case .setProfile, .setUserName:
            return .post
        case .fetchProfileList, .fetchSubPlayList,.fetchFavoriteSongs:
            return .get
        case .editFavoriteSongsOrder:
            return .patch
        }
    }
    
    public var task: Moya.Task {
        switch self {
        case let .setProfile(image):
            return .requestJSONEncodable(RequsetProfileModel(image: image))
        case let .setUserName(name):
            return .requestJSONEncodable(RequsetUserNameModel(username: name))
        case .fetchProfileList, .fetchSubPlayList,.fetchFavoriteSongs:
            return .requestPlain
        case .editFavoriteSongsOrder(ids: let ids):
            return .requestJSONEncodable(RequsetEditFavoriteSongs(songs: ids))
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
