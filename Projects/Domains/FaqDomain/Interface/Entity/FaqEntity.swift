import Foundation

public struct FaqEntity: Equatable {
    public init(
        category: String,
        question: String,
        answer: String,
        isOpen: Bool
    ) {
        self.category = category
        self.question = question
        self.answer = answer
        self.isOpen = isOpen
    }

    public let category, question, answer: String
    public var isOpen: Bool
}
