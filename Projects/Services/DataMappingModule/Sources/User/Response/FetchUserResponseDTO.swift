//
//  FetchUserResponseDTO.swift
//  DataMappingModule
//
//  Created by yongbeomkwak on 12/8/23.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation

public struct FetchUserResponseDTO: Codable, Equatable {
    public let id, platform, name :String
    public let profile: FetchUserResponseDTO.Profile?
    
    public static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.id == rhs.id
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "userId"
        case platform, name, profile
    }
}

public extension FetchUserResponseDTO {
    struct Profile: Codable {
        public let type: String
        public let version: Int
    }
}
