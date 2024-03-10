//
//  FetchProfileListUseCase.swift
//  DomainModule
//
//  Created by KTH on 2023/02/18.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation
import RxSwift

public protocol FetchProfileListUseCase {
    func execute() -> Single<[ProfileListEntity]>
}
