import Foundation

public struct SearchPlaylistEntity: Equatable {
    public init(
        key: String,
        title: String,
        userName: String,
        image: String,
        count: Int,
        `private`: Bool

    ) {
        self.key = key
        self.title = title
        self.userName = userName
        self.image = image
        self.count = count
        self.private = `private`
    }

    public let key, title, userName, image: String
    public let  count: Int
    public let `private`: Bool
}

