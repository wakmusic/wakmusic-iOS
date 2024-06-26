import Foundation
import PlaylistDomainInterface

public struct PlayListBaseResponseDTO: Decodable {
    public let key, imageUrl: String
}

public extension PlayListBaseResponseDTO {
    func toDomain() -> PlaylistBaseEntity {
        PlaylistBaseEntity(key: key, image: imageUrl)
    }
}
