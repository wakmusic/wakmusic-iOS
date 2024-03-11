//
//  RecommendPlayListResponseDTO.swift
//  DataMappingModuleTests
//
//  Created by yongbeomkwak on 2023/02/10.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation
import PlayListDomainInterface

public struct EditPlayListNameResponseDTO: Decodable {
    public let status: Int
}

public extension EditPlayListNameResponseDTO {
    func toDomain(title: String) -> EditPlayListNameEntity {
        EditPlayListNameEntity(title: title, status: status)
    }
}
