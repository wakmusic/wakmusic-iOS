//
//  ArtistListResponseDTO.swift
//  DataMappingModule
//
//  Created by KTH on 2023/02/01.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation

public struct FavoriteSongsResponseDTO: Decodable {
    public let like: Int
    public let id, title, artist, remix,reaction: String
    public let date, start, end: Int
    public let total:FavoriteSongsResponseDTO.Total?
    
    enum CodingKeys: String, CodingKey {
        case title, artist, remix,reaction,date,start,end,total,like
        case id = "songId"
        
    }

}

extension FavoriteSongsResponseDTO{
    
    public struct Total: Codable {
            public let views,last:Int
            public let increase:Int?
    }
    
}
