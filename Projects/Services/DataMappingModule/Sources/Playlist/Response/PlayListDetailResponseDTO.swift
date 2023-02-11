//
//  RecommendPlayListResponseDTO.swift
//  DataMappingModuleTests
//
//  Created by yongbeomkwak on 2023/02/10.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation


public struct SinglePlayListDetailResponseDTO: Decodable {
    public let id, title: String
    public let songs: [SingleSongResponseDTO]?
    public let `public`: Bool?
    public let key,creator_id,image: String?
}
