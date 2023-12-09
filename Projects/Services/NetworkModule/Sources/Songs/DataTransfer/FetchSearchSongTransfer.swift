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
            views: total?.views ?? 0,
            last: total?.last ?? 0,
            date: date.changeDateFormat(origin: "yyMMdd", result: "yyyy.MM.dd")
        )
    }
}

public extension SearchResultResponseDTO {
    
    func toDomain() -> SearchResultEntity {
        SearchResultEntity(song: song.map({$0.toDomain()}), artist: artist.map{$0.toDomain()}, remix: remix.map({$0.toDomain()}))
    }
    
}
