import Foundation

public struct PlayListEntity: Equatable {
    public init(
        id: Int,
        key: String,
        title: String,
        creator_id: String,
        image: String,
        songlist: [String],
        image_version: Int,
        isSelected: Bool = false
    ) {
        self.id = id
        self.key = key
        self.title = title
        self.creator_id = creator_id
        self.image = image
        self.songlist = songlist
        self.image_version = image_version
        self.isSelected = isSelected
    }
    
    public let id,image_version: Int
    public let key,title,creator_id,image:String
    public let songlist:[String]
    public var isSelected: Bool
    
}
