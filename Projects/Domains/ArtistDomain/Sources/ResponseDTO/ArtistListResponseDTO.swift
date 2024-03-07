//
//  ArtistListResponseDTO.swift
//  DataMappingModule
//
//  Created by KTH on 2023/02/01.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import ArtistDomainInterface
import Foundation

public struct ArtistListResponseDTO: Decodable, Equatable {
    public let artistId, name, short: String
    public let description: String
    public let title: ArtistListResponseDTO.Title?
    public let color: ArtistListResponseDTO.Color?
    public let youtube, twitch, instagram: String?
    public let graduated: Bool?
    public let group: ArtistListResponseDTO.Group?
    public let image: ArtistListResponseDTO.Image?

    public static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.artistId == rhs.artistId
    }

    private enum CodingKeys: String, CodingKey {
        case artistId
        case title
        case group, image
        case name, short, description
        case color, youtube, twitch, instagram
        case graduated
    }
}

public extension ArtistListResponseDTO {
    struct Group: Codable {
        public let engName: String
        public let korName: String

        private enum CodingKeys: String, CodingKey {
            case engName = "en"
            case korName = "kr"
        }
    }

    struct Image: Codable {
        public let round: Int
        public let square: Int
    }

    // MARK: - Color
    struct Color: Codable {
        public let background: [[String]]
    }

    // MARK: - Title
    struct Title: Codable {
        public let app: String
    }
}

public extension ArtistListResponseDTO {
    func toDomain() -> ArtistListEntity {
        ArtistListEntity(
            artistId: artistId,
            name: name,
            short: short,
            group: group?.korName ?? "",
            title: title?.app ?? "",
            description: description,
            color: color?.background ?? [],
            youtube: youtube ?? "",
            twitch: twitch ?? "",
            instagram: instagram ?? "",
            imageRoundVersion: image?.round ?? 0,
            imageSquareVersion: image?.square ?? 0,
            graduated: graduated ?? false,
            isHiddenItem: false
        )
    }
}
