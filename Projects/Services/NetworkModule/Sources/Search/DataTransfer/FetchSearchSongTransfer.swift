import DataMappingModule
import DomainModule
import Utility

public extension FetchSearchSongResponseDTO {
    func toDomain() -> [SearchEntity] {
        list.map { $0.toDomain() }
    }
}

public extension SingleSearchSongResponseDTO {
    func toDomain() -> SearchEntity {
        SearchEntity(
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
