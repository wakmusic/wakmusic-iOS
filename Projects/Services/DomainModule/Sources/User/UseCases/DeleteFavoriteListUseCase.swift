//
//  DeleteLikeListUseCase.swift
//  DomainModule
//
//  Created by KTH on 2023/04/03.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation
import RxSwift
import DataMappingModule

public protocol DeleteFavoriteListUseCase {
    func execute(ids: [String]) -> Single<BaseEntity>
}
