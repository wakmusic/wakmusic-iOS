//
//  ArtistListResponseDTO.swift
//  DataMappingModule
//
//  Created by KTH on 2023/02/01.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation

public struct PlayListResponseDTO: Decodable, Equatable {
    public let id:Int
    public let title:String
    public let key,creator_id,image: String?
    public let songlist:[String]
    public let image_version: Int
    

    public static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.id == rhs.id
    }
    
  
}
