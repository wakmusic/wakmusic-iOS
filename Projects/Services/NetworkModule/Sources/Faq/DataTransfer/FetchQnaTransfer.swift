import DataMappingModule
import DomainModule
import Utility

public extension FaqResponseDTO {
    func toDomain() -> FaqEntity {
        FaqEntity(
            category: category,
            question: question,
            description: description,
            isOpen: false
        )
    }
}
