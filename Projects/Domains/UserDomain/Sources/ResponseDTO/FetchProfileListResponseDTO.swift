//
//  FetchProfileListResponseDTO.swift
//  DataMappingModule
//
//  Created by KTH on 2023/02/18.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation
import UserDomainInterface

public struct FetchProfileListResponseDTO: Decodable, Equatable {
    public let type: String?
    public let version: Int
}

public extension FetchProfileListResponseDTO {
    func toDomain() -> ProfileListEntity {
        ProfileListEntity(
            type: type ?? "unknown",
            version: version,
            isSelected: false
        )
    }
}
