import ArtistDomainInterface
import Foundation

public struct ArtistListResponseDTO: Decodable, Equatable {
    let id: String
    let name: ArtistListResponseDTO.Name
    let group: ArtistListResponseDTO.Group
    let info: ArtistListResponseDTO.Info
    let imageURL: ArtistListResponseDTO.ImageURL
    let graduated: Bool

    public static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.id == rhs.id
    }

    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case group
        case info
        case imageURL = "imageUrl"
        case graduated
    }
}

public extension ArtistListResponseDTO {
    struct Name: Decodable {
        let krName: String
        let enName: String

        private enum CodingKeys: String, CodingKey {
            case krName = "kr"
            case enName = "en"
        }
    }

    struct Group: Decodable {
        let name: String
    }

    struct Info: Decodable {
        let title: ArtistListResponseDTO.Info.Title
        let description: String
        let color: ArtistListResponseDTO.Info.Color
        let playlist: ArtistListResponseDTO.Info.Playlist
    }

    struct ImageURL: Decodable {
        let round: String
        let square: String
    }
}

public extension ArtistListResponseDTO.Info {
    struct Title: Decodable {
        let short: String
    }

    struct Color: Decodable {
        let background: [[String]]
    }

    struct Playlist: Decodable {
        let latest, popular, oldest: String
    }
}

public extension ArtistListResponseDTO {
    func toDomain() -> ArtistEntity {
        ArtistEntity(
            id: id,
            krName: name.krName,
            enName: name.enName,
            groupName: group.name,
            title: info.title.short,
            description: info.description,
            personalColor: info.color.background.flatMap { $0 }.first ?? "ffffff",
            roundImage: imageURL.round,
            squareImage: imageURL.square,
            graduated: graduated,
            playlist: ArtistEntity.Playlist(
                latest: info.playlist.latest,
                popular: info.playlist.popular,
                oldest: info.playlist.oldest
            ),
            isHiddenItem: false
        )
    }
}
