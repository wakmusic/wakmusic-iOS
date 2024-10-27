//
//  AppCheckResponseDTO.swift
//  AppDomain
//
//  Created by KTH on 2024/03/04.
//  Copyright © 2024 yongbeomkwak. All rights reserved.
//

import AppDomainInterface
import Foundation

public struct FetchAppCheckResponseDTO: Decodable {
    public let flag: AppCheckFlagType
    public let title, description, version: String?
    public let specialLogo: Bool?
}

public extension FetchAppCheckResponseDTO {
    func toDomain() -> AppCheckEntity {
        return AppCheckEntity(
            flag: flag,
            title: title ?? "",
            description: description ?? "",
            version: version ?? "",
            isSpecialLogo: specialLogo ?? false
        )
    }
}
