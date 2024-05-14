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
    let name: ArtistListResponseDTO.Name?
    let group: ArtistListResponseDTO.Group?
    let info: ArtistListResponseDTO.Info?
    let imageURL: ArtistListResponseDTO.ImageURL?
    let graduated: Bool?

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
        let krName: String
        let enName: String

        private enum CodingKeys: String, CodingKey {
            case krName = "krShort"
            case enName = "en"
        }
    }

    struct Group: Decodable {
        let id: String
        let name: String
    }

    struct Info: Decodable {
        let title: ArtistListResponseDTO.Info.Title
        let description: String
        let color: ArtistListResponseDTO.Info.Color
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
}

public extension ArtistListResponseDTO {
    func toDomain() -> ArtistListEntity {
        ArtistListEntity(
            id: group?.id ?? "",
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
