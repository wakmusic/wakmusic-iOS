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
    public let name: ArtistListResponseDTO.Name?
    public let group: ArtistListResponseDTO.Group?
    public let info: ArtistListResponseDTO.Info?
    public let imageURL: ArtistListResponseDTO.ImageURL?
    public let graduated: Bool?

    public static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.group?.id == rhs.group?.id
    }

    private enum CodingKeys: String, CodingKey {
        case name
        case group
        case info
        case imageURL = "imageUrl"
        case graduated
    }
}

public extension ArtistListResponseDTO {
    struct Name: Decodable {
        public let krName: String
        public let enName: String

        private enum CodingKeys: String, CodingKey {
            case krName = "krShort"
            case enName = "en"
        }
    }

    struct Group: Decodable {
        public let id: String
        public let name: String
    }

    struct Info: Decodable {
        public let title: ArtistListResponseDTO.Info.Title
        public let description: String
        public let color: ArtistListResponseDTO.Info.Color
    }

    struct ImageURL: Decodable {
        public let round: String
        public let square: String
    }
}

public extension ArtistListResponseDTO.Info {
    struct Title: Decodable {
        public let short: String
    }
    struct Color: Decodable {
        public let background: [[String]]
    }
}

public extension ArtistListResponseDTO {
    func toDomain() -> ArtistListEntity {
        ArtistListEntity(
            ID: group?.id ?? "",
            krName: name?.krName ?? "",
            enName: name?.enName ?? "",
            groupName: group?.name ?? "",
            title: info?.title.short ?? "",
            description: info?.description ?? "",
            personalColor: info?.color.background.flatMap { $0 }.first ?? "",
            roundImage: imageURL?.round ?? "",
            squareImage: imageURL?.square ?? "",
            graduated: graduated ?? false,
            isHiddenItem: false
        )
    }
}
