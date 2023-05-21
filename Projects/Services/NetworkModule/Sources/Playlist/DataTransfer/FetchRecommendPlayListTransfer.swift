import DataMappingModule
import DomainModule
import Utility


public extension SingleRecommendPlayListResponseDTO {
    func toDomain() -> RecommendPlayListEntity {
        RecommendPlayListEntity(
            key:key,
            title: title,
            public: `public`,
            image_round_version: image.round,
            image_sqaure_version: image.square
        )
    }
}
