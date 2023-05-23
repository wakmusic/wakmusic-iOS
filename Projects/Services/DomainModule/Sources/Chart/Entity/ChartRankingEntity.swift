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
        increase: Int,
        date: String,
        isSelected: Bool = false
    ) {
        self.id = id
        self.title = title
        self.artist = artist
        self.remix = remix
        self.reaction = reaction
        self.views = views
        self.last = last
        self.increase = increase
        self.date = date
        self.isSelected = isSelected
    }
    
    public let id, title, artist, remix: String
    public let reaction: String
    public let views, last, increase: Int
    public let date: String
    public var isSelected:Bool
    
    public static func == (lhs: ChartRankingEntity, rhs:  ChartRankingEntity) -> Bool {
        lhs.id == rhs.id
    }
}
