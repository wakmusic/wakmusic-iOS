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

public struct PlaylistResponseDTO: Decodable {
    public let title: String
    public let key: String?
    public let user: PlaylistResponseDTO.User
    public let imageUrl: String
    public let songCount: Int
    public let `private`: Bool

    public struct User: Decodable {
        public let handle: String
        public let name: String
    }
}

public extension PlaylistResponseDTO {
    func toDomain() -> PlaylistEntity {
        PlaylistEntity(
            key: key ?? "",
            title: title,
            image: imageUrl,
            songCount: songCount,
            userId: user.handle,
            private: `private`
        )
    }
}
