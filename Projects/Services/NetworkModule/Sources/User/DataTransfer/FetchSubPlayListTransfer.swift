import DataMappingModule
import DomainModule
import Utility


public extension SubPlayListResponseDTO {
    func toDomain() -> SubPlayListEntity {
        
        SubPlayListEntity(
            id: id,
            key: key ??  "",
            title: title,
            creator_id: creator_id ??  "",
            image: image ?? "",
            songs: songs?.map({$0.toDomain()}) ?? []
        )
        
    }
}
