//
//  ArtistListResponseDTO.swift
//  DataMappingModule
//
//  Created by KTH on 2023/02/01.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation
import SongsDomainInterface
import UserDomainInterface

public struct PlayListResponseDTO: Decodable {
    public let title: String
    public let key: String?
    public let user: PlayListResponseDTO.User
    public let image: PlayListResponseDTO.Image
    public let songs: [PlayListResponseDTO.Song]
    public var isSelected: Bool?

    public struct User: Codable {
        public let displayName: String
        public let profile: Profile
    }

    public struct Profile: Codable {
        public let type: String
        public let version: Int
    }

    public struct Image: Codable {
        public let name: String
        public let version: Int
    }

    public struct Song: Codable {
        public let songId: String
        public let title: String
        public let artist: String
        public let remix: String
        public let reaction: String
        public let date: Int
        public let total: PlayListResponseDTO.Song.Total
    }
}

public extension PlayListResponseDTO.Song {
    struct Total: Codable {
        public let views: Int
        public let increase: Int
        public let last: Int
    }
}

public extension PlayListResponseDTO {
    func toDomain() -> PlayListEntity {
        PlayListEntity(
            key: key ?? "",
            title: title,
            image: image.name,
            songlist: songs.map {
                SongEntity(
                    id: $0.songId,
                    title: $0.title,
                    artist: $0.artist,
                    remix: $0.remix,
                    reaction: $0.reaction,
                    views: $0.total.views,
                    last: $0.total.last,
                    date: "\($0.date)"
                )
            },
            image_version: image.version,
            isSelected: isSelected ?? false
        )
    }
}
