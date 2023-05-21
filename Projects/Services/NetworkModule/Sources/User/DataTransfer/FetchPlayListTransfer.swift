import DataMappingModule
import DomainModule
import Utility


public extension PlayListResponseDTO {
    func toDomain() -> PlayListEntity {
        PlayListEntity(
            key: key ??  "",
            title: title,
            image: image.name,
            songlist: songs.map({$0.songId}),
            image_version: image.version,
            isSelected: isSelected ?? false
        )
    }
}
