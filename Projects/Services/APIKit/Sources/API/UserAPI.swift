import Moya
import DataMappingModule
import ErrorModule
import Foundation

public enum UserAPI {
    case setProfile(token:String,image:String)
    case setUserName(token:String,name:String)
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
        }
        
    }
        
        public var method: Moya.Method {
            
            switch self {
                
            case .setProfile,.setUserName:
                return .post
            }
            
        }
        
            public var task: Moya.Task {
                
                switch self {
                    
                case .setProfile(_, image: let image):
                    return .requestJSONEncodable(RequsetProfileModel(image: image))
                    
                case .setUserName(_, name: let name):
                    return .requestJSONEncodable(RequsetUserNameModel(username: name))
                }
            }
    
        public var headers: [String : String]? {
            
            switch self {
                
            case .setProfile(token: let token,_), .setUserName(token: let token,_):
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
