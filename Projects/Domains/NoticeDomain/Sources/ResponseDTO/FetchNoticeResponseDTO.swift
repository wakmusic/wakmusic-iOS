import Foundation
import NoticeDomainInterface

public struct FetchNoticeResponseDTO: Decodable, Equatable {
    public let id: Int
    public let category: String
    public let title: String
    public let content: String?
    public let thumbnail: FetchNoticeResponseDTO.Image?
    public let origins: [FetchNoticeResponseDTO.Image]
    public let createdAt: Double

    public static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.id == rhs.id
    }

    enum CodingKeys: String, CodingKey {
        case id, category, title
        case content = "text"
        case thumbnail
        case origins = "images"
        case createdAt
    }
}

public extension FetchNoticeResponseDTO {
    struct Image: Decodable {
        public let url: String?
        public let link: String?

        enum CodingKeys: String, CodingKey {
            case url = "imageUrl"
            case link = "hyperlinkUrl"
        }
    }
}

public extension FetchNoticeResponseDTO {
    func toDomain() -> FetchNoticeEntity {
        return FetchNoticeEntity(
            id: id,
            category: category,
            title: title,
            content: content ?? "",
            thumbnail: FetchNoticeEntity.Image(
                url: thumbnail?.url ?? "",
                link: thumbnail?.link ?? ""
            ),
            origins: origins.map {
                FetchNoticeEntity.Image(url: $0.url ?? "", link: $0.link ?? "")
            },
            createdAt: createdAt
        )
    }
}
