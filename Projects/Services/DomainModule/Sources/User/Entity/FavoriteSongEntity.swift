import Foundation
import DomainModule

public struct FavoriteSongEntity: Equatable {
    public init(
        id: Int,
        likes: Int,
        song:SongEntity
     
    ) {
        self.id = id
        self.likes = likes
        self.song = song
        
    }
    
    public let id,likes: Int
    public let song:SongEntity
    
}
