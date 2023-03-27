import Foundation

public struct ChartRankingEntity: Equatable {
    public init(
        id: String,
        title: String,
        artist: String,
        remix: String,
        reaction: String,
        views: Int,
        last: Int,
        date: String,
        isSelected: Bool
    ) {
        self.id = id
        self.title = title
        self.artist = artist
        self.remix = remix
        self.reaction = reaction
        self.views = views
        self.last = last
        self.date = date
    }
    
    public let id, title, artist, remix: String
    public let reaction: String
    public let views, last: Int
    public let date: String
    public let isSelected:Bool = false
}
