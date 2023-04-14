//
//  ArtistRepository.swift
//  DomainModule
//
//  Created by KTH on 2023/02/08.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation
import RxSwift
import DataMappingModule
import ErrorModule

public protocol QnaRepository {
    func fetchQnaCategories() -> Single<[QnaCategoryEntity]>
    func fetchQna() -> Single<[QnaEntity]>
}
