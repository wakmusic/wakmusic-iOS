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

public extension AuthLoginResponseDTO {
    func toDomain() -> AuthLoginEntity {
        AuthLoginEntity(
            token:token
        )
    }
}
