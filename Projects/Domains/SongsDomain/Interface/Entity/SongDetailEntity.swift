import Foundation

public struct SongDetailEntity: Hashable, Sendable {
    public init(
        id: String,
        title: String,
        artist: String,
        views: Int,
        date: String,
        likes: Int,
        isLiked: Bool,
        karaokeNumber: SongDetailEntity.KaraokeNumber
    ) {
        self.id = id
        self.title = title
        self.artist = artist
        self.views = views
        self.date = date
        self.likes = likes
        self.isLiked = isLiked
        self.karaokeNumber = karaokeNumber
    }

    public let id, title, artist: String
    public let views: Int
    public let date: String
    public let likes: Int
    public let isLiked: Bool
    public let karaokeNumber: SongDetailEntity.KaraokeNumber

    public struct KaraokeNumber: Hashable, Equatable, Sendable {
        public init (tj: Int?, ky: Int?) {
            self.tj = tj
            self.ky = ky
        }

        public let tj, ky: Int?
    }
}
