//
//  ArtistListResponseDTO.swift
//  DataMappingModule
//
//  Created by KTH on 2023/02/01.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation

public struct FavoriteSongsResponseDTO: Decodable {
    public let likes: Int
    public let song: SingleSongResponseDTO

}
