import Foundation
import UserDomainInterface

public struct FetchUserResponseDTO: Decodable, Equatable {
    public let itemCount, createdAt: Int
    public let id, name, profile, platform: String

    public static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.id == rhs.id
    }

    enum CodingKeys: String, CodingKey {
        case platform = "loginType"
        case id = "handle"
        case name, itemCount
        case profile = "profileUrl"
        case createdAt
    }
}

public extension FetchUserResponseDTO {
    func toDomain() -> UserInfoEntity {
        UserInfoEntity(
            id: id,
            platform: platform,
            name: name,
            profile: profile,
            itemCount: itemCount
        )
    }
}
