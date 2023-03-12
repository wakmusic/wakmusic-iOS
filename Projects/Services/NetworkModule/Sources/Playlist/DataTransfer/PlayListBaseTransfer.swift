import DataMappingModule
import DomainModule
import Utility


public extension PlayListBaseResponseDTO {
    func toDomain() -> PlayListBaseEntity {
        PlayListBaseEntity(status: status,key: key)
    }
}
