import DataMappingModule
import DomainModule
import Utility


public extension SinglePlayListDetailResponseDTO {
    func toDomain() -> PlayListDetailEntity {
        PlayListDetailEntity(
            title: title,
            songs: songs?.map({$0.toDomain()}) ?? [],
            public: `public` ?? false,
            key: key ?? "",
            image: image.name ?? "",
            image_square_version: image.square ?? 0,
            image_round_version: image.round ?? 0,
            version: image.version ?? 0
        )
    }
}
