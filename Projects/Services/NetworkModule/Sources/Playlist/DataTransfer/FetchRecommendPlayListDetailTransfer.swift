import DataMappingModule
import DomainModule
import Utility


public extension SingleRecommendPlayListDetailResponseDTO {
    func toDomain() -> RecommendPlayListDetailEntity {
        RecommendPlayListDetailEntity(
            id: id,
            title: title,
            songs: songs.map({$0.toDomain()}),
            public: `public`
        )
    }
}
