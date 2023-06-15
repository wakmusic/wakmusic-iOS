import DataMappingModule
import DomainModule
import Utility

public extension PlayListResponseDTO {
    func toDomain() -> PlayListEntity {
        PlayListEntity(
            key: key ??  "",
            title: title,
            image: image.name,
            songlist: songs.map {
                SongEntity(
                    id: $0.songId,
                    title: $0.title,
                    artist: $0.artist,
                    remix: $0.remix,
                    reaction: $0.reaction,
                    views: $0.total.views,
                    last: $0.total.last,
                    date: "\($0.date)"
                )
            },
            image_version: image.version,
            isSelected: isSelected ?? false
        )
    }
}
