//
//  LyricHighlightingSenderModel.swift
//  LyricHighlightingFeature
//
//  Created by KTH on 6/3/24.
//  Copyright © 2024 yongbeomkwak. All rights reserved.
//

import Foundation

public struct LyricHighlightingSenderModel {
    let songID: String
    let title: String
    let artist: String

    public init(songID: String, title: String, artist: String) {
        self.songID = songID
        self.title = title
        self.artist = artist
    }
}
