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
    public let name: String
    public let itemCount: Int

    public static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.ID == rhs.ID
    }
}

public extension UserInfo {
    func update(name: String) -> UserInfo {
        return UserInfo(
            ID: self.ID,
            platform: self.platform,
            profile: self.profile,
            name: name,
            itemCount: self.itemCount
        )
    }

    func update(profile: String) -> UserInfo {
        return UserInfo(
            ID: self.ID,
            platform: self.platform,
            profile: profile,
            name: self.name,
            itemCount: self.itemCount
        )
    }

    func update(itemCount: Int) -> UserInfo {
        return UserInfo(
            ID: self.ID,
            platform: self.platform,
            profile: self.profile,
            name: self.name,
            itemCount: itemCount
        )
    }
}
