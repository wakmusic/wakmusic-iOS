import Foundation
import PlaylistDomainInterface
import SongsDomain
import SongsDomainInterface

public struct WMPlaylistDetailResponseDTO: Decodable {
    public let key: String?
    public let title: String
    public let songs: [SingleSongResponseDTO]?
    public let imageURL: String
    public let playlistURL: String

    enum CodingKeys: String, CodingKey {
        case key
        case title
        case songs
        case imageURL = "imageUrl"
        case playlistURL = "playlistUrl"
    }
}

public extension WMPlaylistDetailResponseDTO {
    func toDomain() -> WMPlaylistDetailEntity {
        WMPlaylistDetailEntity(
            key: key ?? "",
            title: title,
            songs: (songs ?? []).map { $0.toDomain() },
            image: imageURL,
            playlistURL: playlistURL
        )
    }
}
