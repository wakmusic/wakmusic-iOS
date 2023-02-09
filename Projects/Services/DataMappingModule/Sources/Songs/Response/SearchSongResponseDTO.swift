//
//  SearchSongResponseDTO.swift
//  DataMappingModule
//
//  Created by yongbeomkwak on 2023/02/07.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation


public struct SingleSearchSongResponseDTO: Decodable {
    public let id, title, artist, remix: String
    public let reaction: String
    public let date, views, last: Int
}
