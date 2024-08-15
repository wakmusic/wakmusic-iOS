import Foundation

struct FetchCreditProfileImageURLResponseDTO: Decodable {
    let profileURL: String

    enum CodingKeys: String, CodingKey {
        case profileURL = "profileUrl"
    }
}
