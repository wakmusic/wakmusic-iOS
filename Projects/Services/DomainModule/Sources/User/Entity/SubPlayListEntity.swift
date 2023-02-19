import Foundation
import DomainModule

public struct SubPlayListEntity: Equatable {
    public init(
        id: Int,
        key:String,
        title:String,
        creator_id:String,
        image:String,
        songs:[SongEntity]
     
    ) {
        self.id = id
        self.key = key
        self.title = title
        self.creator_id = creator_id
        self.image = image
        self.songs = songs
        
    }
    
    public let id: Int
    public let key,title,creator_id,image:String
    public let songs:[SongEntity]
    
}
