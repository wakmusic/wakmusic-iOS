import Foundation

public struct ArtistEntity: Equatable {
    public init(
        id: String,
        krName: String,
        enName: String,
        groupName: String,
        title: String,
        description: String,
        personalColor: String,
        roundImage: String,
        squareImage: String,
        graduated: Bool,
        playlist: ArtistEntity.Playlist,
        isHiddenItem: Bool
    ) {
        self.id = id
        self.krName = krName
        self.enName = enName
        self.groupName = groupName
        self.title = title
        self.description = description
        self.personalColor = personalColor
        self.roundImage = roundImage
        self.squareImage = squareImage
        self.graduated = graduated
        self.playlist = playlist
        self.isHiddenItem = isHiddenItem
    }

    public static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.id == rhs.id
    }

    public let id, krName, enName, groupName: String
    public let title, description: String
    public let personalColor: String
    public let roundImage, squareImage: String
    public let graduated: Bool
    public let playlist: ArtistEntity.Playlist
    public var isHiddenItem: Bool = false
}

public extension ArtistEntity {
    struct Playlist {
        public let latest, popular, oldest: String

        public init(latest: String, popular: String, oldest: String) {
            self.latest = latest
            self.popular = popular
            self.oldest = oldest
        }
    }
}
