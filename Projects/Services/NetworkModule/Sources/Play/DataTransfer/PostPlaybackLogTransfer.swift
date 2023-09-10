//
//  PostPlaybackLogTransfer.swift
//  NetworkModule
//
//  Created by KTH on 2023/08/27.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation
import DataMappingModule
import DomainModule
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
