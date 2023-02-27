import DataMappingModule
import DomainModule
import Utility


public extension EditPlayListNameResponseDTO {
    func toDomain() -> EditPlayListNameEntity {
        EditPlayListNameEntity(title: title, status: status)
    }
}
