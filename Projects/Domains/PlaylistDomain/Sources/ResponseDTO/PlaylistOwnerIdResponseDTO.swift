import Foundation
import PlaylistDomainInterface

public struct PlaylistOwnerIDResponseDTO: Decodable {
    public let ownerID: String

    enum CodingKeys: String, CodingKey {
        case ownerID = "handle"
    }
}

public extension PlaylistOwnerIDResponseDTO {
    func toDomain() -> PlaylistOwnerIDEntity {
        PlaylistOwnerIDEntity(ownerID: ownerID)
    }
}
