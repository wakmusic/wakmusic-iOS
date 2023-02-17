//
//  UserInfoManager.swift
//  Utility
//
//  Created by KTH on 2023/02/17.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation

public struct UserInfo: Codable, Equatable {
    public let ID: String
    public let platform: String
    public let profile: String
    public let displayName: String
    public let firstLoginTime: Int
    public let first: Bool
    
    public static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.ID == rhs.ID
    }
}
