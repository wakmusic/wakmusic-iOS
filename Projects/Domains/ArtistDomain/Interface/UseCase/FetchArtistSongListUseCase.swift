//
//  FetchArtistSongListUseCase.swift
//  DomainModule
//
//  Created by KTH on 2023/02/10.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation
import RxSwift

public protocol FetchArtistSongListUseCase {
    func execute(id: String, sort: ArtistSongSortType, page: Int) -> Single<[ArtistSongListEntity]>
}
