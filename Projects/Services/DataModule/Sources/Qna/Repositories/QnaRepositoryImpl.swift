//
//  ArtistRepositoryImpl.swift
//  DataModule
//
//  Created by KTH on 2023/02/08.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import DataMappingModule
import DomainModule
import ErrorModule
import NetworkModule
import DatabaseModule
import RxSwift

public struct QnaRepositoryImpl: QnaRepository {
        
    private let remoteQnaDataSource: any RemoteQnaDataSource
    
    public init(
        remoteQnaDataSource: RemoteQnaDataSource
    ) {
        self.remoteQnaDataSource = remoteQnaDataSource
    }
    
    public func fetchQnaCategories() -> Single<[QnaCategoryEntity]> {
        remoteQnaDataSource.fetchCategories()
    }
    
    public func fetchQna() -> Single<[QnaEntity]> {
        remoteQnaDataSource.fetchQna()
    }
    
   
}
