import Foundation
import PlaylistDomainInterface

public struct SingleRecommendPlayListResponseDTO: Decodable {
    public let key, title, imageUrl: String
    public let `private`: Bool
    public let songCount: Int
}

public extension SingleRecommendPlayListResponseDTO {
    func toDomain() -> RecommendPlaylistEntity {
        RecommendPlaylistEntity(
            key: key,
            title: title,
            image: imageUrl,
            private: `private`,
            count: songCount
        )
    }
}
