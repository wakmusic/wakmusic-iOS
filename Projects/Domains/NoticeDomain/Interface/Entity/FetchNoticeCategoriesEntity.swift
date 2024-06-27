import Foundation

public struct FetchNoticeCategoriesEntity {
    public init (
        categories: [String]
    ) {
        self.categories = categories
    }

    public let categories: [String]
}
