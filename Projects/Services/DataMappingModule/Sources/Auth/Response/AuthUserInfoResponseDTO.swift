//
//  ArtistListResponseDTO.swift
//  DataMappingModule
//
//  Created by KTH on 2023/02/01.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation

public struct AuthUserInfoResponseDTO: Codable, Equatable {
    public let id, platform, displayName:String
    public let first_login_time:Int
    public let first:Bool
    public static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.id == rhs.id
    }
}
