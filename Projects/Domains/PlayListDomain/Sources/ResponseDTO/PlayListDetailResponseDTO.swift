import Foundation
import PlaylistDomainInterface
import SongsDomain
import SongsDomainInterface
import Utility

public struct SinglePlaylistDetailResponseDTO: Decodable {
    public let key: String?
    public let title: String
    public let songs: [SingleSongResponseDTO]?
    public let imageUrl: String
    public let `private`: Bool
}

public extension SinglePlaylistDetailResponseDTO {
    func toDomain() -> PlaylistDetailEntity {
        PlaylistDetailEntity(
            key: key ?? "",
            title: title,
            songs: (songs ?? []).map { dto in
                return SongEntity(
                    id: dto.songID,
                    title: dto.title,
                    artist: dto.artists.joined(separator: ", "),
                    remix: "",
                    reaction: "",
                    views: dto.views,
                    last: 0,
                    date: dto.date.changeDateFormat(origin: "yyMMdd", result: "yyyy.MM.dd")
                )
            },
            image: imageUrl,
            private: `private`
        )
    }
}
