import Foundation
import PriceDomainInterface

struct PriceResponseDTO: Decodable {
    let price: Int

    public init(price: Int) {
        self.price = price
    }

    enum CodingKeys: String, CodingKey {
        case price = "data"
    }
}

extension PriceResponseDTO {
    func toDomain() -> PriceEntity {
        return PriceEntity(price: price)
    }
}
