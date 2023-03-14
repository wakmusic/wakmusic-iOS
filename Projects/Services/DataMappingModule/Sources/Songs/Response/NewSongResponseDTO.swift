//
//  NewSongResponseDTO.swift
//  DataMappingModule
//
//  Created by KTH on 2023/02/20.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation

public struct NewSongResponseDTO: Decodable {
    public let id, title, artist, remix: String
    public let reaction: String
    public let date, views, last: Int
}
