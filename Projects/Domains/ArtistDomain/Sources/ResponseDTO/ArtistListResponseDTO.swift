//
//  ArtistListResponseDTO.swift
//  DataMappingModule
//
//  Created by KTH on 2023/02/01.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation
import ArtistDomainInterface

public struct ArtistListResponseDTO: Decodable, Equatable {
    public let ID, name, short: String
    public let description: String
    public let title: ArtistListResponseDTO.Title?
    public let color: ArtistListResponseDTO.Color?
    public let youtube, twitch, instagram: String?
    public let graduated: Bool?
    public let group: ArtistListResponseDTO.Group?
    public let image: ArtistListResponseDTO.Image?
    
    public static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.ID == rhs.ID
    }

    private enum CodingKeys: String, CodingKey {
        case ID = "artistId"
        case title
        case group, image
        case name, short, description
        case color, youtube, twitch, instagram
        case graduated
    }
}

public extension ArtistListResponseDTO {
    struct Group: Codable {
        public let en: String
        public let kr: String
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
            ID: ID,
            name: name,
            short: short,
            group: group?.kr ?? "",
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
