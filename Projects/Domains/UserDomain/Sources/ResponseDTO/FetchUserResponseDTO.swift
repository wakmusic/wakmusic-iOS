import Foundation
import UserDomainInterface

#warning("리스폰스에 platform 추가 되면 옵셔널 해제 필요")
public struct FetchUserResponseDTO: Decodable, Equatable {
    public let id, itemCount, createdAt: Int
    public let name, profile: String
    public var platform: String?

    public static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.id == rhs.id
    }

    enum CodingKeys: String, CodingKey {
        case id, name, itemCount
        case profile = "profileUrl"
        case createdAt
        //case platform
    }
}

public extension FetchUserResponseDTO {
    func toDomain() -> UserInfoEntity {
        UserInfoEntity(
            id: String(id),
            platform: platform ?? "알수없음",
            name: name,
            profile: profile,
            version: 0
        )
    }
}
