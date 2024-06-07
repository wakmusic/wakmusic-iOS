//
//  AddSongEntity.swift
//  DomainModule
//
//  Created by yongbeomkwak on 2023/03/14.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation

public struct AddSongEntity: Equatable {
    public init(
        added_songs_length: Int,
        duplicated: Bool
    ) {
        self.added_songs_length = added_songs_length
        self.duplicated = duplicated
    }

    public let added_songs_length: Int
    public let duplicated: Bool
}
