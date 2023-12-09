//
//  FetchNoticeCategoriesUseCase.swift
//  DomainModuleTests
//
//  Created by KTH on 2023/04/08.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation
import RxSwift
import DataMappingModule

public protocol FetchNoticeCategoriesUseCase {
    func execute() -> Single<FetchNoticeCategoriesEntity>
}
