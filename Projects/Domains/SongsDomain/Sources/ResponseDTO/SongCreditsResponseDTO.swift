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
    let vocal, featuring: [String]
    let original: String
    let producing, lyrics, relyrics, compose: [String]
    let arrange, mixing, mastering, session: [String]
    let chorus, vocalGuide, trainer: [String]
}

public extension SongCreditsResponseDTO {
    func toDomain() -> SongCreditsEntity {
        return SongCreditsEntity(
            vocal: vocal,
            featuring: featuring,
            original: original,
            producing: producing,
            lyrics: lyrics,
            relyrics: relyrics,
            compose: compose,
            arrange: arrange,
            mixing: mixing,
            mastering: mastering,
            session: session,
            chorus: chorus,
            vocalGuide: vocalGuide,
            trainer: trainer
        )
    }
}
