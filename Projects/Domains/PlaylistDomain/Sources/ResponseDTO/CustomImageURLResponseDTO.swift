import Foundation
import PlaylistDomainInterface

public struct CustomImageURLResponseDTO: Decodable {
    public let imageURL, presignedURL: String

    enum CodingKeys: String, CodingKey {
        case imageURL = "imageUrl"
        case presignedURL = "presignedUrl"
    }
}

public extension CustomImageURLResponseDTO {
    func toDomain() -> CustomImageURLEntity {
        CustomImageURLEntity(imageURL: imageURL, presignedURL: presignedURL)
    }
}
