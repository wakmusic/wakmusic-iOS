import DataMappingModule
import DomainModule
import Utility


public extension SinglePlayListDetailResponseDTO {
    func toDomain() -> PlayListDetailEntity {
        PlayListDetailEntity(
            id: id ?? "",
            title: title,
            songs: songs?.map({$0.toDomain()}) ?? [],
            public: `public` ?? false,
            key: key ?? "",
            creator_id: creator_id ?? "",
            image: image ?? "",
            image_square_version: image_square_version ?? 0,
            image_version: image_version ?? 0
        )
    }
}
