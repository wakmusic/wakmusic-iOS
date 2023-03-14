import DataMappingModule
import DomainModule
import Utility


public extension SingleRecommendPlayListResponseDTO {
    func toDomain() -> RecommendPlayListEntity {
        RecommendPlayListEntity(
            id: id,
            title: title,
            public: `public`,
            image_round_version: image_round_version ?? 0
        )
    }
}
