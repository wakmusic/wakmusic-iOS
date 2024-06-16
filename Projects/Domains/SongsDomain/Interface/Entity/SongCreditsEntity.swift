//
//  SongCreditsEntity.swift
//  SongsDomain
//
//  Created by KTH on 5/14/24.
//  Copyright © 2024 yongbeomkwak. All rights reserved.
//

import Foundation

public struct SongCreditsEntity {
    public init(
        type: String,
        names: [String]
    ) {
        self.type = type
        self.names = names
    }

    public let type: String
    public let names: [String]
}
