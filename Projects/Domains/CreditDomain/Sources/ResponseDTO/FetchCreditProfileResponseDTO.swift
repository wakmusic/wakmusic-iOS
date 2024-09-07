import CreditDomainInterface
import Foundation

struct FetchCreditProfileResponseDTO: Decodable {
    let name: String
    let imageURL: String?

    enum CodingKeys: String, CodingKey {
        case name
        case imageURL = "profileUrl"
    }
}

extension FetchCreditProfileResponseDTO {
    func toDomain() -> CreditProfileEntity {
        return CreditProfileEntity(
            name: name,
            imageURL: imageURL
        )
    }
}
