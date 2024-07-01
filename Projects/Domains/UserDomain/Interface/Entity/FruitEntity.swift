import Foundation

public struct FruitEntity {
    public init(
        quantity: Int,
        fruitID: String,
        name: String,
        imageURL: String
    ) {
        self.quantity = quantity
        self.fruitID = fruitID
        self.name = name
        self.imageURL = imageURL
    }

    public let quantity: Int
    public let fruitID, name, imageURL: String
    public var imageData: Data?
}
