//
//  RemoteArtistDataSource.swift
//  NetworkModuleTests
//
//  Created by KTH on 2023/02/08.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import DataMappingModule
import ErrorModule
import DomainModule
import RxSwift
import Foundation

public protocol RemoteArtistDataSource {
    func fetchArtistList() -> Single<[ArtistListEntity]>
}
