//
//  RemoteArtistDataSourceImpl.swift
//  NetworkModuleTests
//
//  Created by KTH on 2023/02/08.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import ArtistDomainInterface
import BaseDomain
import Foundation
import RxSwift

public final class RemoteArtistDataSourceImpl: BaseRemoteDataSource<ArtistAPI>, RemoteArtistDataSource {
    public func fetchArtistList() -> Single<[ArtistListEntity]> {
        request(.fetchArtistList)
            .map([ArtistListResponseDTO].self)
            .map { $0.map { $0.toDomain() } }
    }

    public func fetchArtistSongList(id: String, sort: ArtistSongSortType, page: Int) -> Single<[ArtistSongListEntity]> {
        request(.fetchArtistSongList(id: id, sort: sort, page: page))
            .map([ArtistSongListResponseDTO].self)
            .map { $0.map { $0.toDomain() } }
    }
}
