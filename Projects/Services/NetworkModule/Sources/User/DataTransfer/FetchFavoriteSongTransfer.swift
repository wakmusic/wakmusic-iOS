import DataMappingModule
import DomainModule
import Utility


public extension FavoriteSongsResponseDTO {
    func toDomain() -> FavoriteSongEntity {
        FavoriteSongEntity(
            likes: like,
            song: SongEntity(id: id, title: title, artist: artist, remix: remix, reaction: reaction, views: total.views, last: total.last, date: date.changeDateFormat(origin: "yyMMdd", result: "yyyy.MM.dd")),
            isSelected: false
        )
    }
}
