import Foundation
import PlaylistDomainInterface

public struct CustomImageUrlResponseDTO: Decodable {
    public let imageUrl , presignedUrl: String

}

public extension CustomImageUrlResponseDTO {
    func toDomain() -> CustomImageUrlEntity {
        CustomImageUrlEntity(imageUrl: imageUrl, presignedUrl: presignedUrl)
    }
}
