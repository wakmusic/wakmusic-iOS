import Moya
import DataMappingModule
import ErrorModule
import Foundation
import KeychainModule

public enum UserAPI {
    case setProfile(image: String)
    case setUserName(name: String)
    case fetchSubPlayList
    case fetchFavoriteSongs
}

public struct RequsetProfileModel:Encodable {
    var image:String
}

public struct RequsetUserNameModel:Encodable {
    var username:String
}

extension UserAPI: WMAPI {

    public var domain: WMDomain {
        .user
    }

    public var urlPath: String {
        switch self {
        case .setProfile:
            return "/profile/set"
        case .setUserName:
            return "/username"
        case .fetchSubPlayList:
            return "/playlists"
        case .fetchFavoriteSongs:
            return "/likes"
        }
    }
        
    public var method: Moya.Method {
        switch self {
        case .setProfile,.setUserName:
            return .post
        case .fetchSubPlayList,.fetchFavoriteSongs:
            return .get
        }
    }
    
    public var task: Moya.Task {
        switch self {
        case let .setProfile(image):
            return .requestJSONEncodable(RequsetProfileModel(image: image))
        case let .setUserName(name):
            return .requestJSONEncodable(RequsetUserNameModel(username: name))
        case .fetchSubPlayList,.fetchFavoriteSongs:
            return .requestPlain
        }
    }

    public var headers: [String : String]? {
        let token: String = KeychainImpl().load(type: .accessToken)
        switch self {
        case .setProfile,
             .setUserName,
             .fetchSubPlayList,
             .fetchFavoriteSongs:
            return ["Authorization":"Bearer \(token)"]
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
