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
            first_login_time: firstLoginTime,
            first: first,
            profile: profile?.type ?? "",
            version: profile?.version ?? 0
        )
    }
}
