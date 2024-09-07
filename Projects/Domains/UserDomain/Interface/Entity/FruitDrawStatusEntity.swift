import Foundation

public struct FruitDrawStatusEntity {
    public let canDraw: Bool
    public let lastDraw: FruitDrawStatusEntity.LastDraw

    public init(canDraw: Bool, lastDraw: FruitDrawStatusEntity.LastDraw) {
        self.canDraw = canDraw
        self.lastDraw = lastDraw
    }
}

public extension FruitDrawStatusEntity {
    struct LastDraw {
        public let drawAt: Double
        public let fruit: FruitDrawStatusEntity.LastDraw.Fruit

        public init(drawAt: Double, fruit: FruitDrawStatusEntity.LastDraw.Fruit) {
            self.drawAt = drawAt
            self.fruit = fruit
        }
    }
}

public extension FruitDrawStatusEntity.LastDraw {
    struct Fruit {
        public let fruitID, name, imageURL: String

        public init(fruitID: String, name: String, imageURL: String) {
            self.fruitID = fruitID
            self.name = name
            self.imageURL = imageURL
        }

        enum CodingKeys: String, CodingKey {
            case fruitID = "fruitId"
            case name
            case imageURL = "imageUrl"
        }
    }
}
