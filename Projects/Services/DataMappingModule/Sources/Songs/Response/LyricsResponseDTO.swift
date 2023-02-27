//
//  LyricsResponseDTO.swift
//  DataMappingModule
//
//  Created by YoungK on 2023/02/22.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation

public struct LyricsResponseDTO: Decodable {
    public let identifier, text, styles: String
    public let start, end: Double
}
