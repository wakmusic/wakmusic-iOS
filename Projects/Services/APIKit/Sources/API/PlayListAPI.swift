import Moya
import DataMappingModule
import ErrorModule
import Foundation

public enum PlayListAPI {
    case fetchRecommendPlayList
    case fetchRecommendPlayListDetail(id:String)
}

extension PlayListAPI: WMAPI {
    public var domain: WMDomain {
        .playlist
    }

    public var urlPath: String {
        switch self {
            
        case .fetchRecommendPlayList:
            return "/recommended"
     
        case .fetchRecommendPlayListDetail(id: let id):
            return "/recommended/\(id)"
        }
    }
        
        public var method: Moya.Method {
            return .get
        }
        
        public var task: Moya.Task {
            switch self {
            case .fetchRecommendPlayList:
                return .requestPlain
            case .fetchRecommendPlayListDetail(id:_):
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
