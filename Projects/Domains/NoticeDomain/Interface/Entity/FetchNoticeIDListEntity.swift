import Foundation

public struct FetchNoticeIDListEntity {
    public init(
        status: String,
        data: [Int]
    ) {
        self.status = status
        self.data = data
    }

    public let status: String
    public let data: [Int]
}
