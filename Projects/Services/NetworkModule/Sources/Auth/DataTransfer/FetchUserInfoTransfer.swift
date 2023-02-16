//
//  FetchArtistListTransfer.swift
//  NetworkModuleTests
//
//  Created by KTH on 2023/02/08.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation
import DataMappingModule
import DomainModule
import Utility

public extension AuthUserInfoResponseDTO {
    func toDomain() -> AuthUserInfoEntity {
        AuthUserInfoEntity(
            id: id,
            platform: platform,
            displayName: displayName,
            first_login_time: first_login_time,
            first: first
        )
    }
}
