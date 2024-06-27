import Foundation
import PlaylistDomainInterface
import SongsDomain
import SongsDomainInterface
import Utility

public struct SinglePlayListDetailResponseDTO: Decodable {
    public let key: String?
    public let title: String
    public let songs: [SingleSongResponseDTO]?
    public let imageUrl: String
    public let `private`: Bool
    public let user: SinglePlayListDetailResponseDTO.UserResponseDTO
}

public extension SinglePlayListDetailResponseDTO {
    struct UserResponseDTO: Decodable {
        public let handle: String
        public let name: String
    }
}

public extension SinglePlayListDetailResponseDTO {
    func toDomain() -> PlaylistDetailEntity {
        PlaylistDetailEntity(
            key: key ?? "",
            title: title,
            songs: (songs ?? []).map { $0.toDomain() },
            image: imageUrl,
            private: `private`,
            userId: user.handle,
            userName: user.name
        )
    }
}
