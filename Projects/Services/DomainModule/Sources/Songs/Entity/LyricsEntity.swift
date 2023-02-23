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
        identifier: String,
        start: Int,
        end: Int,
        text: String,
        styles: String
    ) {
        self.identifier = identifier
        self.start = start
        self.end = end
        self.text = text
        self.styles = styles
    }
    
    public let identifier, text, styles: String
    public let start, end: Int
}
