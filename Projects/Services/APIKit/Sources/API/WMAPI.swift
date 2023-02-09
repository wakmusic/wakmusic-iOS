import Moya
import Foundation
import ErrorModule
import KeychainModule

public protocol WMAPI: TargetType, JwtAuthorizable {
    var domain: WMDomain { get }
    var urlPath: String { get }
    var errorMap: [Int: WMError] { get }
}

public extension WMAPI {
    var baseURL: URL {
        URL(string: "https://test.wakmusic.xyz")!
    }
    
    var imageBaseURL: URL {
        URL(string: "https://static.wakmusic.xyz")!
    }

    var path: String {
        domain.asURLString + urlPath
    }

    var headers: [String: String]? {
        ["Content-Type": "application/json"]
    }

    var validationType: ValidationType {
        return .successCodes
    }
}

public enum WMDomain: String {
    case auth = "api/auth"
    case charts = "api/charts"
    case songs = "api/songs"
    case artist = "api/artist"
    case user = "api/user"
    case playlist = "api/playlist"
    case like = "api/like"
    case common = "static"
}

extension WMDomain {
    var asURLString: String {
        "/\(self.rawValue)"
    }
}
