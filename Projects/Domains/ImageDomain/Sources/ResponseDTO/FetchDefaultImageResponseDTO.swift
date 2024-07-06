import Foundation
import ImageDomainInterface

public struct FetchDefaultImageResponseDTO: Decodable, Equatable {
    public let type: String
    public let name: String
    public let url: String
}

public extension FetchDefaultImageResponseDTO {
    func toDomain() -> DefaultImageEntity {
        DefaultImageEntity(
            name: name,
            url: url
        )
    }
}
