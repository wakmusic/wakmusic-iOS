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
    let names: [Credit]

    public struct Credit: Decodable {
        let name: String
        let isArtist: Bool
        let artistID: String?

        enum CodingKeys: String, CodingKey {
            case name
            case isArtist = "isArtist"
            case artistID = "artistId"
        }
    }
}

public extension SongCreditsResponseDTO {
    func toDomain() -> SongCreditsEntity {
        return SongCreditsEntity(
            type: type,
            names: names.map {
                SongCreditsEntity.Credit(
                    name: $0.name,
                    isArtist: $0.isArtist,
                    artistID: $0.artistID
                )
            }
        )
    }
}
