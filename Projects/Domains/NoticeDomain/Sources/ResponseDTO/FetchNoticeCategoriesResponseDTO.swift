import Foundation
import NoticeDomainInterface

public struct FetchNoticeCategoriesResponseDTO: Decodable {
    public let categories: [String]
}

public extension FetchNoticeCategoriesResponseDTO {
    func toDomain() -> FetchNoticeCategoriesEntity {
        return FetchNoticeCategoriesEntity(
            categories: categories
        )
    }
}
