import Foundation

public struct FavoriteSongEntity: Equatable {
    public init(
        id: Int,
        likes: Int,
        song: SongEntity,
        isSelected: Bool
    ) {
        self.id = id
        self.likes = likes
        self.song = song
        self.isSelected = isSelected
    }
    
    public let id,likes: Int
    public let song: SongEntity
    public var isSelected: Bool
}
