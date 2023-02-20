//
//  fetchNewSongUseCase.swift
//  DomainModule
//
//  Created by KTH on 2023/02/20.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation
import DataMappingModule
import ErrorModule
import RxSwift

public protocol FetchNewSongUseCase {
    func execute(type: NewSongGroupType) -> Single<[NewSongEntity]>
}
