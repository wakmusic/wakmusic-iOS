import Foundation

public struct FavoriteSongEntity: Equatable {
    public init(
        likes: Int,
        song: SongEntity,
        isSelected: Bool
    ) {
        self.likes = likes
        self.song = song
        self.isSelected = isSelected
    }
    
    public let likes: Int
    public let song: SongEntity
    public var isSelected: Bool
}
