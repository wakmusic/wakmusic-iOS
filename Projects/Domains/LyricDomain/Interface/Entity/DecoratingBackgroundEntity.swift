import Foundation

public struct DecoratingBackgroundEntity {
    public init(
        name: String,
        image: String,
        isSelected: Bool = false
    ) {
        self.name = name
        self.image = image
    }

    public let name, image: String
    public var isSelected: Bool = false
}
