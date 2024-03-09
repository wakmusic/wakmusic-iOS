import Foundation

public struct FaqCategoryEntity: Equatable {
    public init(
        categories: [String]
    ) {
        self.categories = categories
    }

    public let categories: [String]
}
