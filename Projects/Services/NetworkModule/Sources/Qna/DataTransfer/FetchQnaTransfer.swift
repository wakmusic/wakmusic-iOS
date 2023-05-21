import DataMappingModule
import DomainModule
import Utility


public extension QnaResponseDTO {
    func toDomain() -> QnaEntity {
        QnaEntity(
            create_at: createAt,
            category: category?.category ?? "",
            question: question,
            description: description,
            isOpen: false
        )
    }
}
