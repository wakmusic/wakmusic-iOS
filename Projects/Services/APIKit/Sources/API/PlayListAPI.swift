import Moya
import DataMappingModule
import ErrorModule
import Foundation

public enum PlayListAPI {
    case fetchRecommendPlayList
}

extension PlayListAPI: WMAPI {
    public var domain: WMDomain {
        .playlist
    }

    public var urlPath: String {
        switch self {
            
        case .fetchRecommendPlayList:
            return "/recommended"
        }
    }
        
        public var method: Moya.Method {
            return .get
        }
        
        public var task: Moya.Task {
            switch self {
           
            
            case .fetchRecommendPlayList:
                return .requestPlain
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
