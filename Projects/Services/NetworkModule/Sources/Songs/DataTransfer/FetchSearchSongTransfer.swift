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
            views: total.views,
            last: total.last,
            date: date.changeDateFormat(origin: "yyMMdd", result: "yyyy.MM.dd")
        )
    }
}
