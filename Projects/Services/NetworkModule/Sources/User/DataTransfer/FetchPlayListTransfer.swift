import DataMappingModule
import DomainModule
import Utility


public extension PlayListResponseDTO {
    func toDomain() -> PlayListEntity {
        
        PlayListEntity(
            id: id,
            key: key ??  "",
            title: title,
            creator_id: creator_id ??  "",
            image: image ?? "",
            songlist: songlist
        )
        
    }
}
