//
//  LikeResponseDTO.swift
//  DataMappingModuleTests
//
//  Created by YoungK on 2023/04/03.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation

public struct LikeResponseDTO: Codable {
    public let status: Int?
    public let likes: Int
}
