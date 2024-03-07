//
//  AppCheckFlagType.swift
//  AppDomain
//
//  Created by KTH on 2024/03/04.
//  Copyright © 2024 yongbeomkwak. All rights reserved.
//

import Foundation

public enum AppCheckFlagType: Int, Decodable {
    case normal = 1
    case event
    case update
    case forceUpdate
    case offline
}
