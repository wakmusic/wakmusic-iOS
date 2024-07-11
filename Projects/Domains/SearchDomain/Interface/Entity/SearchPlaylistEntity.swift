import Foundation

public struct SearchPlaylistEntity: Hashable, Equatable {
    public init(
        key: String,
        title: String,
        ownerId: String,
        userName: String,
        image: String,
        date: String,
        count: Int,
        isPrivate: Bool

    ) {
        self.key = key
        self.title = title
        self.ownerId = ownerId
        self.userName = userName
        self.image = image
        self.date = date
        self.count = count
        self.isPrivate = isPrivate
    }

    public let key, title, ownerId, image, date, userName: String
    public let count: Int
    public let isPrivate: Bool

    public func hash(into hasher: inout Hasher) {
        hasher.combine(key)
    }

    public static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.key == rhs.key
    }
}
