//
//  SearchResultResponseDTO.swift
//  DataMappingModule
//
//  Created by yongbeomkwak on 12/9/23.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation

public struct SearchResultResponseDTO: Decodable {
    public let song: [SingleSongResponseDTO]
    public let artist: [SingleSongResponseDTO]
    public let remix: [
        SingleSongResponseDTO
    ]
}
