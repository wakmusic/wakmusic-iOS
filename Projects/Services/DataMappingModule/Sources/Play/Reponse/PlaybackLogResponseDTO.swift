//
//  PlaybackLogResponseDTO.swift
//  DataMappingModule
//
//  Created by KTH on 2023/08/27.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation

public struct PlaybackLogResponseDTO: Decodable {
    public let songId, title, artist: String
}
