import Foundation

public struct PlayListEntity: Equatable {
    public init(
        key: String,
        title: String,
        image: String,
        songlist: [String],
        image_version: Int,
        isSelected: Bool = false
    ) {
        self.key = key
        self.title = title
        self.image = image
        self.songlist = songlist
        self.image_version = image_version
        self.isSelected = isSelected
    }
    
    public let image_version: Int
    public let key,title,image:String
    public let songlist:[String]
    public var isSelected: Bool
    
}
