//
//  FetchLikeResponseDTO.swift
//  DataMappingModule
//
//  Created by yongbeomkwak on 12/9/23.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation

public struct FetchLikeResponseDTO: Codable {
    public let songId: String
    public let like: Int
}
