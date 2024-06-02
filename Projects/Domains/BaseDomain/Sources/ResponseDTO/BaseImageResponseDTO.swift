import Foundation
import BaseDomainInterface

public struct BaseImageResponseDTO: Decodable {
    private let imageUrl: String
}

extension BaseImageResponseDTO {
    public func toDomain() -> BaseImageEntity {
        return BaseImageEntity(image: imageUrl)
    }
}
