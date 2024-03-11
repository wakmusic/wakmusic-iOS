//
//  RecommendPlayListResponseDTO.swift
//  DataMappingModuleTests
//
//  Created by yongbeomkwak on 2023/02/10.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation
import PlayListDomainInterface

public struct PlayListBaseResponseDTO: Decodable {
    public let key: String
    public let status: Int
}

public extension PlayListBaseResponseDTO {
    func toDomain() -> PlayListBaseEntity {
        PlayListBaseEntity(status: status, key: key)
    }
}
