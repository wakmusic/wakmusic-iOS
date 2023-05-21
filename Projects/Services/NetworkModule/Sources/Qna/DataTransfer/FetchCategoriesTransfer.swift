import DataMappingModule
import DomainModule
import Utility


public extension QnaCategoryResponseDTO {
    func toDomain() -> QnaCategoryEntity {
        QnaCategoryEntity(
            category: category
        )
    }
}
