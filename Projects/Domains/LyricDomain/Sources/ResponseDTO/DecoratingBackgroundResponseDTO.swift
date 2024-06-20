import Foundation
import LyricDomainInterface

public struct DecoratingBackgroundResponseDTO: Decodable {
    let name: String
    let image: String

    private enum CodingKeys: String, CodingKey {
        case name
        case image = "imageUrl"
    }
}

public extension DecoratingBackgroundResponseDTO {
    func toDomain() -> DecoratingBackgroundEntity {
        return .init(name: name, image: image)
    }
}
