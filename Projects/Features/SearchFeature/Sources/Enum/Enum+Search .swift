//
//  Enum + Search .swift
//  SearchFeature
//
//  Created by yongbeomkwak on 2023/02/14.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation
import RxDataSources
import SongsDomainInterface

public typealias SearchSectionModel = SectionModel<(TabPosition, Int), SongEntity>

public enum TabPosition: Int {
    case all = 0
    case song
    case artist
    case remix
}
