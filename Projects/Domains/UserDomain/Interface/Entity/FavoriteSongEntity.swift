import Foundation
import SongsDomainInterface

public struct FavoriteSongEntity: Equatable {
    public init(
        like: Int,
        song: SongEntity,
        isSelected: Bool
    ) {
        self.like = like
        self.song = song
        self.isSelected = isSelected
    }

    public let like: Int
    public let song: SongEntity
    public var isSelected: Bool
}
