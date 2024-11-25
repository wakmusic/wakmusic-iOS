//
//  FetchArtistListUseCase.swift
//  DomainModule
//
//  Created by KTH on 2023/02/08.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation
import RxSwift

public protocol FetchFaqCategoriesUseCase: Sendable {
    func execute() -> Single<FaqCategoryEntity>
}
