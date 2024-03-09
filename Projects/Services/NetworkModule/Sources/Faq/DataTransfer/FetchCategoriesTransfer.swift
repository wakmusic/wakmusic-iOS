import DataMappingModule
import DomainModule
import Utility

public extension FaqCategoryResponseDTO {
    func toDomain() -> FaqCategoryEntity {
        FaqCategoryEntity(
            categories: categories
        )
    }
}
