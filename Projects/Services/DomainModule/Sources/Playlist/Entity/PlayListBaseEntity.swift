//
//  RecommendPlayListEntity.swift
//  DomainModuleTests
//
//  Created by yongbeomkwak on 2023/02/10.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation

public struct PlayListBaseEntity: Equatable {
    public init(
        status:Int,
        key:String,
        description:String = ""
    ) {
        self.status = status
        self.key = key
        self.description = description
    }
    public let status: Int
    public let key: String
    public var description:String

}
