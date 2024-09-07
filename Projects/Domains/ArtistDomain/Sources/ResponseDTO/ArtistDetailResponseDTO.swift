import ArtistDomainInterface
import Foundation

public struct ArtistDetailResponseDTO: Decodable, Equatable {
    let id: String
    let name: ArtistDetailResponseDTO.Name
    let group: ArtistDetailResponseDTO.Group
    let info: ArtistDetailResponseDTO.Info
    let imageURL: ArtistDetailResponseDTO.ImageURL
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

public extension ArtistDetailResponseDTO {
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
        let title: ArtistDetailResponseDTO.Info.Title
        let description: String
        let color: ArtistDetailResponseDTO.Info.Color
        let playlist: ArtistDetailResponseDTO.Info.Playlist
    }

    struct ImageURL: Decodable {
        let round: String
        let square: String
    }
}

public extension ArtistDetailResponseDTO.Info {
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

public extension ArtistDetailResponseDTO {
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
