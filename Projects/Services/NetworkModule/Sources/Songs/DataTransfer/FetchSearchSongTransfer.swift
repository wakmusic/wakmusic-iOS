import DataMappingModule
import DomainModule
import Utility


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
