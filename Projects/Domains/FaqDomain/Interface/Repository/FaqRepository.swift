//
//  ArtistRepository.swift
//  DomainModule
//
//  Created by KTH on 2023/02/08.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation
import RxSwift

public protocol FaqRepository {
    func fetchQnaCategories() -> Single<FaqCategoryEntity>
    func fetchQna() -> Single<[FaqEntity]>
}
