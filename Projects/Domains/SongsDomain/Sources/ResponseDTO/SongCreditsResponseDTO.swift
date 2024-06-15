//
//  FetchSongCreditsResponseDTO.swift
//  SongsDomain
//
//  Created by KTH on 5/14/24.
//  Copyright © 2024 yongbeomkwak. All rights reserved.
//

import Foundation
import SongsDomainInterface

public struct SongCreditsResponseDTO: Decodable {
    let type: String
    let names: [String]
}

public extension SongCreditsResponseDTO {
    func toDomain() -> SongCreditsEntity {
        return SongCreditsEntity(
            type: type,
            names: names
        )
    }
}
