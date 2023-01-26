import Moya

public enum JwtTokenType: String {
    case accessToken = "Authorization"
    case refreshToken = "refresh-token"
    case none
}

public protocol JwtAuthorizable {
    var jwtTokenType: JwtTokenType { get }
}
