//
//  FetchArtistSongListTransfer.swift
//  NetworkModule
//
//  Created by KTH on 2023/02/10.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation
import DataMappingModule
import DomainModule
import Utility

public extension ArtistSongListResponseDTO {
    func toDomain() -> ArtistSongListEntity {
        ArtistSongListEntity(
            ID: ID,
            title: title,
            artist: artist,
            remix: remix,
            reaction: reaction,
            date: date.changeDateFormat(origin: "yyMMdd", result: "yyyy.MM.dd"),
            views: views,
            last: last,
            isSelected: false
        )
    }
}
