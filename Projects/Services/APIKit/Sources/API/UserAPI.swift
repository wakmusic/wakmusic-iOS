import Moya
import DataMappingModule
import ErrorModule
import Foundation

public enum UserAPI {
    case setProfile(token:String,image:String)
}

public struct RequsetProfileModel:Encodable {
    var image:String
}

extension UserAPI: WMAPI {

    public var domain: WMDomain {
        .user
    }

    public var urlPath: String {
        
        switch self {
            
        case .setProfile:
            return "/profile/set"
        }
        
    }
        
        public var method: Moya.Method {
            return .post
        }
        
        public var task: Moya.Task {
            
            switch self {
                
            case .setProfile(_, image: let image):
                return .requestJSONEncodable(RequsetProfileModel(image: image))
            }
                
            
        }
    
        public var headers: [String : String]? {
            
            switch self {
                
            case .setProfile(token: let token,_):
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
