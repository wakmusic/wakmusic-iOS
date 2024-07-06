import Foundation
import ImageDomainInterface

public struct FetchProfileListResponseDTO: Decodable, Equatable {
    public let type: String
    public let name: String
    public let url: String
}

public extension FetchProfileListResponseDTO {
    func toDomain() -> ProfileListEntity {
        ProfileListEntity(
            name: name,
            url: url
        )
    }
}
