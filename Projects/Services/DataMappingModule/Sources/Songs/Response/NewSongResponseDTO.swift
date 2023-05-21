//
//  NewSongResponseDTO.swift
//  DataMappingModule
//
//  Created by KTH on 2023/02/20.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation

public struct NewSongResponseDTO: Decodable {
    public let id, title, artist, remix: String
    public let reaction: String
    public let date: Int
    public let total: NewSongResponseDTO.Total?
    
    public static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.id == rhs.id
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "songId"
        case title, artist, remix, reaction, date, total
    }
}

public extension NewSongResponseDTO {
    struct Total: Codable {
        public let views: Int
        public let last: Int
    }
}
