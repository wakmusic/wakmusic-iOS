import Foundation
import PlaylistDomainInterface

public struct PlaylistOwnerIdResponseDTO: Decodable {
    public let ownerID: String
    
    enum CodingKeys : String , CodingKey {
        case ownerID = "handle"
    }
    
}

public extension PlaylistOwnerIdResponseDTO {
    func toDomain() -> PlaylistOwnerIdEntity {
        PlaylistOwnerIdEntity(ownerID: ownerID)
    }
}
