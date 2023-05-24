//
//  CheckVersionResponseDTO.swift
//  DataMappingModuleTests
//
//  Created by yongbeomkwak on 2023/05/23.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation

public struct AppInfoDTO: Codable {
    public let flag: AppInfoFlagType
    public let title, description, version: String?
}
