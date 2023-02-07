//
//  SearchType.swift
//  DataMappingModule
//
//  Created by yongbeomkwak on 2023/02/07.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation

public enum SearchType: String, Codable {
    case title
    case artist
    case remix

    public var display: String {
        switch self {
        case .title:
            return "제목"
        case .artist:
            return "가수"
        case .remix:
            return "조교"
        }
    }
}
