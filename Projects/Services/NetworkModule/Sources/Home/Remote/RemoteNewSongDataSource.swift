//
//  RemoteNewSongDataSource.swift
//  NetworkModule
//
//  Created by KTH on 2023/02/20.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation
import DataMappingModule
import ErrorModule
import DomainModule
import RxSwift

public protocol RemoteNewSongDataSource {
    func fetchNewSong(type: NewSongGroupType) -> Single<[NewSongEntity]>
}
