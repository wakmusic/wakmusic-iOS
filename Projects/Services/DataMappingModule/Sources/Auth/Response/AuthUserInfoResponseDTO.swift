//
//  ArtistListResponseDTO.swift
//  DataMappingModule
//
//  Created by KTH on 2023/02/01.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation

public struct AuthUserInfoResponseDTO: Codable, Equatable {
    public let id, platform, displayName :String
    public let firstLoginTime: Int
    public let first: Bool
    public let profile: AuthUserInfoResponseDTO.Profile?
    
    public static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.id == rhs.id
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "userId"
        case platform, displayName, firstLoginTime, first, profile
    }
}

public extension AuthUserInfoResponseDTO {
    struct Profile: Codable {
        public let type: String
        public let version: Int
    }
}
