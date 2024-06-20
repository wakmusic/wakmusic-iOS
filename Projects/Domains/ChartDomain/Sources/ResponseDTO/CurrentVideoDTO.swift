import ChartDomainInterface
import Foundation

struct CurrentVideoDTO: Decodable {
    let data: String
}

extension CurrentVideoDTO {
    func toDomain() -> CurrentVideoEntity {
        return CurrentVideoEntity(id: data)
    }
}
