//
//  RemoteNewSongDataSourceImpl.swift
//  NetworkModule
//
//  Created by KTH on 2023/02/20.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import APIKit
import RxSwift
import DataMappingModule
import DomainModule
import ErrorModule
import Foundation

public final class RemoteNewSongDataSourceImpl: BaseRemoteDataSource<SongsAPI>, RemoteNewSongDataSource {
    public func fetchNewSong(type: NewSongGroupType) ->  Single<[NewSongEntity]> {
        request(.fetchNewSong(type: type))
            .map([NewSongResponseDTO].self)
            .map{$0.map{$0.toDomain()}}
    }
}
