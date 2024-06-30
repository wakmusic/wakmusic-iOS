import Foundation
import SongsDomainInterface

public struct PlaylistEntity {
    public init(
        key: String,
        title: String,
        image: String,
        songCount: Int,
        userId: String,
        isSelected: Bool = false
    ) {
        self.key = key
        self.title = title
        self.image = image
        self.isSelected = isSelected
        self.songCount = songCount
        self.userId = userId
    }

    public let key, title, image, userId: String
    public let songCount: Int
    public var isSelected: Bool
}
