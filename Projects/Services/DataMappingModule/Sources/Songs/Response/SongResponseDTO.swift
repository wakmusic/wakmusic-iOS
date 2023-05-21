//
//  SearchSongResponseDTO.swift
//  DataMappingModule
//
//  Created by yongbeomkwak on 2023/02/07.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation


public struct SingleSongResponseDTO: Decodable {
    public let id, title, artist, remix,reaction: String
    public let date, start, end: Int
    public let total:SingleSongResponseDTO.Total
    
    enum CodingKeys: String, CodingKey {
        case title, artist, remix,reaction,date,start,end,total
        case id = "songId"
        
    }
}


extension SingleSongResponseDTO{
    
    public struct Total: Codable {
            public let views,last:Int
            public let increase:Int?
    }
    
}
