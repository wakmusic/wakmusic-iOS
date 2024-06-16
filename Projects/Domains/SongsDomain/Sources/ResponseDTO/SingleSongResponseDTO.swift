//
//  SearchSongResponseDTO.swift
//  DataMappingModule
//
//  Created by yongbeomkwak on 2023/02/07.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation
import SongsDomainInterface
import Utility

public struct SingleSongResponseDTO: Decodable {
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

public extension SingleSongResponseDTO {
    struct KaraokeNumber: Decodable {
        public let TJ, KY: Int?
    }
}

public extension SingleSongResponseDTO {
    func toDomain() -> SongEntity {
        return SongEntity(
            id: songID,
            title: title,
            artist: artists.joined(separator: ", "),
            remix: "",
            reaction: "",
            views: views,
            last: 0,
            date: date.changeDateFormat(origin: "yyMMdd", result: "yyyy.MM.dd"),
            karaokeNumber: .init(TJ: karaokeNumber.TJ, KY: karaokeNumber.KY)
        )
    }
}
