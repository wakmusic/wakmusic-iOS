import Foundation
import PlaylistDomainInterface
import SongsDomain
import SongsDomainInterface

public struct WmPlaylistDetailResponseDTO: Decodable {
    public let key: String?
    public let title: String
    public let songs: [SingleSongResponseDTO]?
    public let imageUrl: String
}


public extension WmPlaylistDetailResponseDTO {
    func toDomain() -> WmPlaylistDetailEntity {
        WmPlaylistDetailEntity(
            key: key ?? "",
            title: title,
            songs: (songs ?? []).map { $0.toDomain() },
            image: imageUrl
        )
    }
}
