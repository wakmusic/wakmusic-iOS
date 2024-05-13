//
//  LyricsEntity.swift
//  DomainModule
//
//  Created by YoungK on 2023/02/22.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation

public struct LyricsEntity: Equatable {
    public init(
        text: String
    ) {
        self.text = text
    }

    public let text: String
}
