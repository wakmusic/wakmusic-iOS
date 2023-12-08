//
//  ArtistListResponseDTO.swift
//  DataMappingModule
//
//  Created by KTH on 2023/02/01.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation

public struct ArtistListResponseDTO: Codable, Equatable {
    public let ID, name, short: String
    public let description: String
    public let title: ArtistListResponseDTO.Title?
    public let color: ArtistListResponseDTO.Color?
    public let youtube, twitch, instagram: String?
    public let graduated: Bool?
    public let group: ArtistListResponseDTO.Group?
    public let image: ArtistListResponseDTO.Image?
    
    public static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.ID == rhs.ID
    }

    private enum CodingKeys: String, CodingKey {
        case ID = "artistId"
        case title = "appTitle"
        case group, image
        case name, short, description
        case color, youtube, twitch, instagram
        case graduated
    }
}

public extension ArtistListResponseDTO {
    struct Group: Codable {
        public let en: String
        public let kr: String
    }
    struct Image: Codable {
        public let round: Int
        public let square: Int
        public let clear: Int
    }
    
    // MARK: - Color
    struct Color: Codable {
        public let background: [[String]]
        public let card: [[String]]
    }
    
    // MARK: - Title
    struct Title: Codable {
        public let app, web: String
    }
}
