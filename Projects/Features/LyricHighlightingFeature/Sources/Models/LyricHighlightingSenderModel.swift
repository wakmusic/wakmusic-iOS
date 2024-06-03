//
//  LyricHighlightingSenderModel.swift
//  LyricHighlightingFeature
//
//  Created by KTH on 6/3/24.
//  Copyright © 2024 yongbeomkwak. All rights reserved.
//

import Foundation

public struct LyricHighlightingRequiredModel {
    let songID: String
    let title: String
    let artist: String
    let highlightingItems: [String]

    public init(
        songID: String,
        title: String,
        artist: String,
        highlightingItems: [String]
    ) {
        self.songID = songID
        self.title = title
        self.artist = artist
        self.highlightingItems = highlightingItems
    }
}
