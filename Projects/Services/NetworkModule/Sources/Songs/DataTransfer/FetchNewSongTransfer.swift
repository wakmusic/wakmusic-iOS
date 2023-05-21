//
//  FetchNewSongTransfer.swift
//  NetworkModule
//
//  Created by KTH on 2023/02/20.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import DataMappingModule
import DomainModule
import Utility

public extension NewSongResponseDTO {
    func toDomain() -> NewSongEntity {
        NewSongEntity(
            id: id,
            title: title,
            artist: artist,
            remix: remix,
            reaction: reaction,
            views: total?.views ?? 0,
            last: total?.last ?? 0,
            date: date
        )
    }
}
