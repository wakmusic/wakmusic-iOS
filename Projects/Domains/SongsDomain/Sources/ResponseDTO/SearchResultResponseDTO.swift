//
//  SearchResultResponseDTO.swift
//  DataMappingModule
//
//  Created by yongbeomkwak on 12/9/23.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation
import SongsDomainInterface

public struct SearchResultResponseDTO: Decodable {
    public let song: [SingleSongResponseDTO]
    public let artist: [SingleSongResponseDTO]
    public let remix: [
        SingleSongResponseDTO
    ]
}

public extension SearchResultResponseDTO {
    func toDomain() -> SearchResultEntity {
        SearchResultEntity(
            song: song.map { $0.toDomain() },
            artist: artist.map { $0.toDomain() },
            remix: remix.map { $0.toDomain() }
        )
    }
}
