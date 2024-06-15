import Foundation

public struct SearchPlaylistEntity: Equatable {
    public init(
        key: String,
        title: String,
        userName: String,
        image: String,
        count: Int,
        isPrivate: Bool

    ) {
        self.key = key
        self.title = title
        self.userName = userName
        self.image = image
        self.count = count
        self.isPrivate = isPrivate
    }

    public let key, title, userName, image: String
    public let count: Int
    public let isPrivate: Bool
}
