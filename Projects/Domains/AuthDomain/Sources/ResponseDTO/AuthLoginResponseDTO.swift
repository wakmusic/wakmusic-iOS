import AuthDomainInterface
import Foundation

public struct AuthLoginResponseDTO: Decodable, Equatable {
    public let accessToken: String
    public let expiresIn: TimeInterval
    public let refreshToken: String?

    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.accessToken == rhs.accessToken
            && lhs.expiresIn == rhs.expiresIn
            && lhs.refreshToken == rhs.refreshToken
    }
}

public extension AuthLoginResponseDTO {
    func toDomain() -> AuthLoginEntity {
        AuthLoginEntity(
            token: accessToken
        )
    }
}
