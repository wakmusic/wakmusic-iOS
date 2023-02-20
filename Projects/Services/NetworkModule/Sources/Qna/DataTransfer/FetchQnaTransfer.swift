import DataMappingModule
import DomainModule
import Utility


public extension QnaResponseDTO {
    func toDomain() -> QnaEntity {
        
        QnaEntity(
            id:id,
            create_at:create_at,
            category:category,
            question:question,
            description:description,
            isOpen: false
        )
        
    }
}
