//
//  FetchArtistListUseCaseImpl.swift
//  DataModule
//
//  Created by KTH on 2023/02/08.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation
import RxSwift
import DataMappingModule
import DomainModule
import ErrorModule

public struct FetchQnaUseCaseImpl: FetchQnaUseCase {
   
    
   

    private let qnaRepository: any QnaRepository

    public init(
        qnaRepository: QnaRepository
    ) {
        self.qnaRepository = qnaRepository
    }
    
    public func execute() -> Single<[QnaEntity]> {
        qnaRepository.fetchQna()
    }


}
