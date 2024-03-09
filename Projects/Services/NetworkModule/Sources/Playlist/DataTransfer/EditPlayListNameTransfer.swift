import DataMappingModule
import DomainModule
import Utility

public extension EditPlayListNameResponseDTO {
    func toDomain(title: String) -> EditPlayListNameEntity {
        EditPlayListNameEntity(title: title, status: status)
    }
}
