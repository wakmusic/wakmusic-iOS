import ArtistDomainInterface
import Foundation

public struct ArtistSubscriptionStatusResponseDTO: Decodable {
    let status: String
    let isSubscription: Bool

    private enum CodingKeys: String, CodingKey {
        case status
        case isSubscription = "data"
    }
}

public extension ArtistSubscriptionStatusResponseDTO {
    func toDomain() -> ArtistSubscriptionStatusEntity {
        return ArtistSubscriptionStatusEntity(
            isSubscription: status == "success" ? isSubscription : false
        )
    }
}
