import DataMappingModule
import DomainModule
import Utility


public extension SingleSongResponseDTO {
    func toDomain() -> SongEntity {
        SongEntity(
            id: id,
            title: title,
            artist: artist,
            remix: remix,
            reaction: reaction,
            views: views,
            last: last,
            date: date.toWMDateString()
        )
    }
}
