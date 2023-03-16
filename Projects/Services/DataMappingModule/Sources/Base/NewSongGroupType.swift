//
//  NewSongGroupType.swift
//  DataMappingModule
//
//  Created by KTH on 2023/02/20.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation

public enum NewSongGroupType: String, Codable {
    case all
    case woowakgood
    case isedol
    case gomem

    public var display: String {
        switch self {
        case .all:
            return "전체"
        case .woowakgood:
            return "우왁굳"
        case .isedol:
            return "이세돌"
        case .gomem:
            return "고멤"
        }
    }
}
