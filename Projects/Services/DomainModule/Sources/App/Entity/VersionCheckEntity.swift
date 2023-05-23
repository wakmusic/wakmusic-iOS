//
//  VersionCheckEntity.swift
//  DomainModuleTests
//
//  Created by yongbeomkwak on 2023/05/23.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation

public struct VersionCheckEntity: Equatable {
    public init(
        flag:Int,
        title:String,
        description:String,
        version:String
    )
    {
        self.flag = flag
        self.title = title
        self.description = description
        self.version = version
    }
    
    public let flag:Int
    public let title,description,version:String
}
