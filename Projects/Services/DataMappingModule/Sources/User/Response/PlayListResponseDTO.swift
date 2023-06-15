//
//  ArtistListResponseDTO.swift
//  DataMappingModule
//
//  Created by KTH on 2023/02/01.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation

public struct PlayListResponseDTO: Decodable{
    public let title: String
    public let key: String?
    public let user: PlayListResponseDTO.User
    public let image: PlayListResponseDTO.Image
    public let songs: [PlayListResponseDTO.Song]
    public var isSelected: Bool?

    public struct User: Codable {
        public let displayName:String
        public let profile:Profile
    }

    public struct Profile: Codable {
        public let type:String
        public let version:Int
    }
    
    public struct Image: Codable {
        public let name:String
        public let version:Int
    }
    
    public struct Song: Codable {
        public let songId: String
        public let title: String
        public let artist: String
        public let remix: String
        public let reaction: String
        public let date: Int
        public let total: PlayListResponseDTO.Song.Total
    }
}

public extension PlayListResponseDTO.Song{
    struct Total: Codable {
        public let views: Int
        public let increase: Int
        public let last: Int
    }
}
