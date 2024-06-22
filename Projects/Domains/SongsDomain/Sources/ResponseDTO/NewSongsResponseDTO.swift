//
//  NewSongsResponseDTO.swift
//  DataMappingModule
//
//  Created by KTH on 2023/11/15.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation
import SongsDomainInterface

public struct NewSongsResponseDTO: Decodable {
    public let songID, title: String
    public let artists: [String]
    public let date, views, likes: Int
    public let karaokeNumber: SingleSongResponseDTO.KaraokeNumber

    enum CodingKeys: String, CodingKey {
        case title, artists, date, views, likes
        case songID = "videoId"
        case karaokeNumber
    }
}

public extension NewSongsResponseDTO {
    struct KaraokeNumber: Decodable {
        public let TJ, KY: Int?
    }
}

public extension NewSongsResponseDTO {
    func toDomain() -> NewSongsEntity {
        return NewSongsEntity(
            id: songID,
            title: title,
            artist: artists.joined(separator: ", "),
            views: views,
            date: date.changeDateFormat(origin: "yyMMdd", result: "yyyy.MM.dd"),
            karaokeNumber: .init(TJ: karaokeNumber.TJ, KY: karaokeNumber.KY)
        )
    }
}
