//
//  FetchArtistListUseCaseImpl.swift
//  DataModule
//
//  Created by KTH on 2023/02/08.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation
import FaqDomainInterface
import RxSwift

public struct FetchFaqCategoriesUseCaseImpl: FetchFaqCategoriesUseCase {
    private let faqRepository: any FaqRepository

    public init(
        faqRepository: FaqRepository
    ) {
        self.faqRepository = faqRepository
    }

    public func execute() -> Single<FaqCategoryEntity> {
        faqRepository.fetchQnaCategories()
    }
}
