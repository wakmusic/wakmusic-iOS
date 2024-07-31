import Foundation
import PlaylistDomainInterface

public struct PlaylistOwnerIdResponseDTO: Decodable {
    public let ownerId: String
    
    enum CodingKeys : String , CodingKey {
        case ownerId = "handle"
    }
    
}

public extension PlaylistOwnerIdResponseDTO {
    func toDomain() -> PlaylistOwnerIdEntity {
        PlaylistOwnerIdEntity(ownerId: ownerId)
    }
}
