import Foundation

public struct BaseEntity {
    public init(
        status: Int,
        description: String = ""
    ) {
        self.status = status
        self.description = description
    }

    public let status: Int
    public var description: String = ""
}
