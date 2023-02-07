//
//  FetchArtistListTransfer.swift
//  NetworkModuleTests
//
//  Created by KTH on 2023/02/08.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation
import DataMappingModule
import DomainModule
import Utility

public extension ArtistListResponseDTO {
    func toDomain() -> ArtistListEntity {
        ArtistListEntity(
            ID: ID,
            name: name,
            short: short,
            group: group,
            title: title,
            description: description,
            color: color ?? [],
            youtube: youtube ?? "",
            twitch: twitch ?? "",
            instagram: instagram ?? ""
        )
    }
}
