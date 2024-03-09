//
//  FetchNoticeCategoriesUseCase.swift
//  DomainModuleTests
//
//  Created by KTH on 2023/04/08.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import DataMappingModule
import Foundation
import RxSwift

public protocol FetchNoticeCategoriesUseCase {
    func execute() -> Single<FetchNoticeCategoriesEntity>
}
