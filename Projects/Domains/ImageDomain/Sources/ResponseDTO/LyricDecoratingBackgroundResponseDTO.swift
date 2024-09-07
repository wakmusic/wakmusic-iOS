import Foundation
import ImageDomainInterface

public struct LyricDecoratingBackgroundResponseDTO: Decodable {
    let name: String
    let url: String

    private enum CodingKeys: String, CodingKey {
        case name
        case url
    }
}

public extension LyricDecoratingBackgroundResponseDTO {
    func toDomain() -> LyricDecoratingBackgroundEntity {
        return .init(name: name, url: url)
    }
}
