import Foundation
import SongsDomainInterface

public struct PlaylistEntity: Equatable {
    public init(
        key: String,
        title: String,
        image: String,
        songCount: Int,
        userId: String,
        private: Bool,
        isSelected: Bool = false
    ) {
        self.key = key
        self.title = title
        self.image = image
        self.private = `private`
        self.isSelected = isSelected
        self.songCount = songCount
        self.userId = userId
    }

    public let key, title, image, userId: String
    public let songCount: Int
    public var `private`, isSelected: Bool
}
