import Foundation

struct TokenDTO: Equatable, Decodable {
    let accessToken: String

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
    }
}
