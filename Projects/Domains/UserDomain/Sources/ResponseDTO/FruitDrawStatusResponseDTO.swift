import Foundation
import UserDomainInterface

public struct FruitDrawStatusResponseDTO: Decodable {
    public let canDraw: Bool
    public let lastDraw: FruitDrawStatusResponseDTO.LastDraw?
}

public extension FruitDrawStatusResponseDTO {
    struct LastDraw: Decodable {
        public let drawAt: Double
        public let fruit: FruitDrawStatusResponseDTO.LastDraw.Fruit
    }
}

public extension FruitDrawStatusResponseDTO.LastDraw {
    struct Fruit: Decodable {
        public let fruitID, name, imageURL: String

        enum CodingKeys: String, CodingKey {
            case fruitID = "fruitId"
            case name
            case imageURL = "imageUrl"
        }
    }
}

public extension FruitDrawStatusResponseDTO {
    func toDomain() -> FruitDrawStatusEntity {
        return FruitDrawStatusEntity(
            canDraw: canDraw,
            lastDraw: FruitDrawStatusEntity.LastDraw(
                drawAt: lastDraw?.drawAt ?? 0,
                fruit: FruitDrawStatusEntity.LastDraw.Fruit(
                    fruitID: lastDraw?.fruit.fruitID ?? "",
                    name: lastDraw?.fruit.name ?? "",
                    imageURL: lastDraw?.fruit.imageURL ?? ""
                )
            )
        )
    }
}
