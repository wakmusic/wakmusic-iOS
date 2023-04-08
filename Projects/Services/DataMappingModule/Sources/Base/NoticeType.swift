//
//  NoticeType.swift
//  DataMappingModule
//
//  Created by KTH on 2023/04/08.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation

public enum NoticeType: String {
    case all
    case currently
    
    public var addPathString: String {
        switch self {
        case .all:
            return "/all"
        case .currently:
            return ""
        }
    }
}
