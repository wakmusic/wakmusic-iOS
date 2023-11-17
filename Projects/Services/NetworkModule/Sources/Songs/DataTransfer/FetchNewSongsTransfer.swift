//
//  FetchNewSongsTransfer.swift
//  NetworkModule
//
//  Created by KTH on 2023/11/15.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import DataMappingModule
import DomainModule
import Utility

public extension NewSongsResponseDTO {
    func toDomain() -> NewSongsEntity {
        return NewSongsEntity(
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
