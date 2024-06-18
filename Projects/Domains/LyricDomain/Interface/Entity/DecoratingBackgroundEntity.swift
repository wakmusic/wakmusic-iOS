import Foundation

public struct DecoratingBackgroundEntity {
    public init(
        name: String,
        image: String
    ) {
        self.name = name
        self.image = image
    }
    
    public let name, image: String
}
