import Foundation

public struct FaqEntity: Equatable {
    public init(
        category: String,
        question: String,
        description: String,
        isOpen: Bool
    ) {
        self.category = category
        self.question = question
        self.description = description
        self.isOpen = isOpen
    }

    public let category, question, description: String
    public var isOpen: Bool
}
