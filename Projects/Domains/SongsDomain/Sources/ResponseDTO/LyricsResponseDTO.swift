//
//  LyricsResponseDTO.swift
//  DataMappingModule
//
//  Created by YoungK on 2023/02/22.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation
import SongsDomainInterface

public struct LyricsResponseDTO: Decodable {
    let provider: String
    let lyrics: [LyricsResponseDTO.Lyric]
}

extension LyricsResponseDTO {
    struct Lyric: Decodable {
        let text: String
    }
}

public extension LyricsResponseDTO {
    func toDomain() -> LyricsEntity {
        return .init(
            provider: provider,
            lyrics: lyrics.map { lyric -> LyricsEntity.Lyric in
                return LyricsEntity.Lyric(text: lyric.text)
            }
        )
    }
}
