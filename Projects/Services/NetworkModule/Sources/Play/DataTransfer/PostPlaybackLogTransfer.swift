//
//  PostPlaybackLogTransfer.swift
//  NetworkModule
//
//  Created by KTH on 2023/08/27.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import DataMappingModule
import DomainModule
import Foundation
import Utility

public extension PlaybackLogResponseDTO {
    func toDomain() -> PlaybackLogEntity {
        return PlaybackLogEntity(
            id: songId,
            title: title,
            artist: artist
        )
    }
}
