import Foundation

public struct ProfileListEntity: Equatable {
    public init(
        name: String,
        url: String
    ) {
        self.name = name
        self.url = url
    }

    public let name: String
    public let url: String
    public var isSelected: Bool = false
}
