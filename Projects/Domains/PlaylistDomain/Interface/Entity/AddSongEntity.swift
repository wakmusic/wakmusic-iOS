import Foundation

public struct AddSongEntity: Equatable {
    public init(
        addedSongCount: Int,
        duplicated: Bool
    ) {
        self.addedSongCount = addedSongCount
        self.duplicated = duplicated
    }

    public let addedSongCount: Int
    public let duplicated: Bool
}
