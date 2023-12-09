import DataMappingModule
import DomainModule
import Utility


public extension FavoriteSongsResponseDTO {
    func toDomain() -> FavoriteSongEntity {
        FavoriteSongEntity(
            likes: like,
            song: SongEntity(id: id, title: title, artist: artist, remix: remix, reaction: reaction, views: total?.views ?? 0, last: total?.last ?? 0, date: date.changeDateFormat(origin: "yyMMdd", result: "yyyy.MM.dd")),
            isSelected: false
        )
    }
}
