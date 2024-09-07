import Foundation
import NoticeDomainInterface

public struct FetchNoticeIDListDTO: Decodable {
    let status: String
    let data: [Int]
}

public extension FetchNoticeIDListDTO {
    func toDomain() -> FetchNoticeIDListEntity {
        return FetchNoticeIDListEntity(status: status, data: data)
    }
}
