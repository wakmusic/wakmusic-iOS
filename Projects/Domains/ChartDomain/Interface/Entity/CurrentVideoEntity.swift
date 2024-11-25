import Foundation

public struct CurrentVideoEntity: Hashable, Sendable {
    public let id: String

    public init(id: String) {
        self.id = id
    }
}
