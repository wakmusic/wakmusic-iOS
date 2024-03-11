//
//  FetchUserResponseDTO.swift
//  DataMappingModule
//
//  Created by yongbeomkwak on 12/8/23.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation
import UserDomainInterface

public struct FetchUserResponseDTO: Decodable, Equatable {
    public let id, platform, name: String
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

public extension FetchUserResponseDTO {
    func toDomain() -> UserInfoEntity {
        UserInfoEntity(
            id: id,
            platform: platform,
            name: name,
            profile: profile?.type ?? "",
            version: profile?.version ?? 0
        )
    }
}
