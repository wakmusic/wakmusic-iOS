//
//  FetchArtistListTransfer.swift
//  NetworkModuleTests
//
//  Created by KTH on 2023/02/08.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import DataMappingModule
import DomainModule
import Foundation
import Utility

public extension NaverUserInfoResponseDTO {
    func toDomain() -> NaverUserInfoEntity {
        NaverUserInfoEntity(
            resultcode: resultcode,
            message: message,
            id: response.id,
            nickname: response.nickname
        )
    }
}
