import DataMappingModule
import DomainModule
import Utility


public extension FavoriteSongsResponseDTO {
    func toDomain() -> FavoriteSongEntity {
        
        FavoriteSongEntity(
            id: id,
            likes: likes,
            song: song.toDomain())
       
        
    }
}
