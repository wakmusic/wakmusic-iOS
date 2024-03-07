//
//  ArtistListResponseDTO.swift
//  DataMappingModule
//
//  Created by KTH on 2023/02/01.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation

public struct AuthLoginResponseDTO: Codable, Equatable {
    public let token: String
    public static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.token == rhs.token
    }
}
