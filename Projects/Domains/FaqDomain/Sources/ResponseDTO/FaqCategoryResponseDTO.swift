import FaqDomainInterface
import Foundation

public struct FaqCategoryResponseDTO: Decodable, Equatable {
    public let categories: [String]
}

public extension FaqCategoryResponseDTO {
    func toDomain() -> FaqCategoryEntity {
        FaqCategoryEntity(
            categories: categories
        )
    }
}
