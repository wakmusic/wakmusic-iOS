import Foundation
import ChartDomainInterface

struct CurrentVideoDTO: Decodable {
    let data: String
}

extension CurrentVideoDTO {
    func toDomain() -> CurrentVideoEntity {
        return CurrentVideoEntity(id: data)
    }
}
