import Foundation
import ImageDomainInterface

public struct FetchProfileListResponseDTO: Decodable, Equatable {
    public let type: String?
    public let version: Int
}

public extension FetchProfileListResponseDTO {
    func toDomain() -> ProfileListEntity {
        ProfileListEntity(
            type: type ?? "unknown",
            version: version,
            isSelected: false
        )
    }
}
