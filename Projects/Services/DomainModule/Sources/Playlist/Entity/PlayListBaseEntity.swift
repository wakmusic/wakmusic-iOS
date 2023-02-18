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
        key:String
    ) {
        self.key = key
    }
    
    public let key: String

}
