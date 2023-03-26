//
//  PlayState+Public.swift
//  PlayerFeature
//
//  Created by YoungK on 2023/03/25.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation
import DomainModule

public extension PlayState {
    func loadAndAppendUniqueSong(_ song: SongEntity) {
        self.playList.appendIfUnique(item: song)
        self.load(at: song)
    }
}
