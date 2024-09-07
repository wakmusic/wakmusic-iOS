//
//  fetchNewSongsUseCase.swift
//  DomainModule
//
//  Created by KTH on 2023/11/15.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation
import RxSwift

public protocol FetchNewSongsUseCase {
    func execute(type: NewSongGroupType, page: Int, limit: Int) -> Single<[NewSongsEntity]>
}
