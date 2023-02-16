//
//  NaverUserInfoResponseDTO.swift
//  DataMappingModule
//
//  Created by yongbeomkwak on 2023/02/15.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation

public struct NaverUserInfoEntity: Equatable {
    
   
    
 
    public init(
        resultcode: String,
        message: String,
        id:String,
        nickname:String
    ) {
        self.resultcode = resultcode
        self.message = message
        self.id = id
        self.nickname = nickname
    }
    
    public let resultcode, message ,id, nickname : String
    
    
    public static func == (lhs: NaverUserInfoEntity, rhs: NaverUserInfoEntity) -> Bool {
        lhs.id == rhs.id
    }
   
}



