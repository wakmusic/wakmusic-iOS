import Foundation

public struct ProfileListEntity: Equatable {
    public init(
        type: String,
        version: Int,
        isSelected: Bool
    ) {
        self.type = type
        self.version = version
        self.isSelected = false
    }

    public let type: String
    public var isSelected: Bool
    public var version: Int
}
