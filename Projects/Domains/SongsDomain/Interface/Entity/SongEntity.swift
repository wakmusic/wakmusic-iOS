import Foundation

public struct SongEntity: Hashable {
    public init(
        id: String,
        title: String,
        artist: String,
        views: Int,
        date: String,
        likes: Int = 0,
        isSelected: Bool = false,
        karaokeNumber: SongEntity.KaraokeNumber = .init(TJ: nil, KY: nil)
    ) {
        self.id = id
        self.title = title
        self.artist = artist
        self.views = views
        self.date = date
        self.likes = likes
        self.isSelected = isSelected
        self.karaokeNumber = karaokeNumber
    }

    public let id, title, artist: String
    public let views: Int
    public let date: String
    public let likes: Int
    public var isSelected: Bool
    public let karaokeNumber: SongEntity.KaraokeNumber

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

public extension SongEntity {
    struct KaraokeNumber: Hashable, Equatable {
        public init (TJ: Int?, KY: Int?) {
            self.TJ = TJ
            self.KY = KY
        }

        public let TJ, KY: Int?
    }
}
