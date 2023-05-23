//
//  FetchCheckVersionTransfer.swift
//  NetworkModuleTests
//
//  Created by yongbeomkwak on 2023/05/23.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation
import DataMappingModule
import DomainModule
import Utility

public extension CheckVersionResponseDTO {
    func toDomain() -> VersionCheckEntity {
        
        return VersionCheckEntity(
            flag:flag,
            title:title ?? "",
            description:description ?? "",
            version:version ?? ""
        )
        
    }
}
