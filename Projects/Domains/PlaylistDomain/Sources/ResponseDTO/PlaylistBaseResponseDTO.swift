import Foundation
import PlaylistDomainInterface

public struct PlaylistBaseResponseDTO: Decodable {
    public let key, imageUrl: String
}

public extension PlaylistBaseResponseDTO {
    func toDomain() -> PlaylistBaseEntity {
        PlaylistBaseEntity(key: key, image: imageUrl)
    }
}
