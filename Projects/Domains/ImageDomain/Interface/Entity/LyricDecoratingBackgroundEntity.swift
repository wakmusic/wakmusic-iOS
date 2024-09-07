import Foundation

public struct LyricDecoratingBackgroundEntity {
    public init(
        name: String,
        url: String
    ) {
        self.name = name
        self.url = url
    }

    public let name, url: String
    public var isSelected: Bool = false
}
