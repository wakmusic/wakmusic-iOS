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
    let vocal, featuring: [String]?
    let original: String?
    let producing, lyrics, relyrics, compose: [String]?
    let arrange, mixing, mastering, session: [String]?
    let chorus, vocalGuide, trainer: [String]?
}

public extension SongCreditsResponseDTO {
    func toDomain() -> SongCreditsEntity {
        return SongCreditsEntity(
            vocal: (vocal ?? []).joined(separator: ", "),
            featuring: (featuring ?? []).joined(separator: ", "),
            original: original ?? "",
            producing: (producing ?? []).joined(separator: ", "),
            lyrics: (lyrics ?? []).joined(separator: ", "),
            relyrics: (relyrics ?? []).joined(separator: ", "),
            compose: (compose ?? []).joined(separator: ", "),
            arrange: (arrange ?? []).joined(separator: ", "),
            mixing: (mixing ?? []).joined(separator: ", "),
            mastering: (mastering ?? []).joined(separator: ", "),
            session: (session ?? []).joined(separator: ", "),
            chorus: (chorus ?? []).joined(separator: ", "),
            vocalGuide: (vocalGuide ?? []).joined(separator: ", "),
            trainer: (trainer ?? []).joined(separator: ", ")
        )
    }
}
