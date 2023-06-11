//
//  AppInfoFlagType.swift
//  DataMappingModule
//
//  Created by KTH on 2023/05/24.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation

public enum AppInfoFlagType: Int, Codable {
    case normal = 1
    case event
    case update
    case forceUpdate
    case offline
}
