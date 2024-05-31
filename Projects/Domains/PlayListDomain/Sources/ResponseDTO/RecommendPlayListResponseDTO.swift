import Foundation
import PlayListDomainInterface

public struct SingleRecommendPlayListResponseDTO: Decodable {
    public let key, title, imageUrl: String
    public let `private`: Bool
    public let songCount: Int
}

public extension SingleRecommendPlayListResponseDTO {
    func toDomain() -> RecommendPlayListEntity {
        RecommendPlayListEntity(
            key: key ,
            title: title,
            image: imageUrl,
            private: `private`,
            count: songCount
        )
    }
}
