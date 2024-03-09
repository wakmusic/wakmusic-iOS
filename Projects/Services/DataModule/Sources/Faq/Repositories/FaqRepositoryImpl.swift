//
//  ArtistRepositoryImpl.swift
//  DataModule
//
//  Created by KTH on 2023/02/08.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import DatabaseModule
import DataMappingModule
import DomainModule
import ErrorModule
import NetworkModule
import RxSwift

public struct FaqRepositoryImpl: FaqRepository {
    private let remoteFaqDataSource: any RemoteFaqDataSource

    public init(
        remoteFaqDataSource: RemoteFaqDataSource
    ) {
        self.remoteFaqDataSource = remoteFaqDataSource
    }

    public func fetchQnaCategories() -> Single<FaqCategoryEntity> {
        remoteFaqDataSource.fetchCategories()
    }

    public func fetchQna() -> Single<[FaqEntity]> {
        remoteFaqDataSource.fetchQna()
    }
}
