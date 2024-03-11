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
    public let identifier, text, styles: String
    public let start, end: Double
}

public extension LyricsResponseDTO {
    func toDomain() -> LyricsEntity {
        LyricsEntity(
            identifier: identifier,
            start: start,
            end: end,
            text: text,
            styles: styles
        )
    }
}
