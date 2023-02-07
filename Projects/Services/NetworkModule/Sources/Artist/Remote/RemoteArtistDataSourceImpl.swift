//
//  RemoteArtistDataSourceImpl.swift
//  NetworkModuleTests
//
//  Created by KTH on 2023/02/08.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import APIKit
import RxSwift
import DataMappingModule
import DomainModule
import ErrorModule
import Foundation

public final class RemoteArtistDataSourceImpl: BaseRemoteDataSource<ArtistAPI>, RemoteArtistDataSource {
    public func fetchArtistList() -> Single<[ArtistListEntity]> {
        request(.fetchArtistList)
            .map([ArtistListResponseDTO].self)
            .map { $0.map { $0.toDomain() } }
    }
}
