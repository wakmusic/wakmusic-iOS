import Foundation
import PlayListDomainInterface

public struct PlayListBaseResponseDTO: Decodable {
    public let key, imageUrl: String
}

public extension PlayListBaseResponseDTO {
    func toDomain() -> PlayListBaseEntity {
        PlayListBaseEntity(key: key, image: imageUrl)
    }
}
