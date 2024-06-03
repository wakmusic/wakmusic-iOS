import BaseDomainInterface
import Foundation

public struct BaseImageResponseDTO: Decodable {
    private let imageUrl: String
}

public extension BaseImageResponseDTO {
    func toDomain() -> BaseImageEntity {
        return BaseImageEntity(image: imageUrl)
    }
}
