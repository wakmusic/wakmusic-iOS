import Foundation
import UserDomainInterface

public struct FruitListResponseDTO: Decodable {
    public let quantity: Int?
    public let fruitID, name, imageURL: String

    enum CodingKeys: String, CodingKey {
        case quantity
        case fruitID = "fruitId"
        case name
        case imageURL = "imageUrl"
    }
}

public extension FruitListResponseDTO {
    func toDomain() -> FruitEntity {
        .init(
            quantity: quantity ?? -1,
            fruitID: fruitID,
            name: name,
            imageURL: imageURL
        )
    }
}
