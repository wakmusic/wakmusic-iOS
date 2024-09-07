//
//  FetchLyricsUseCase.swift
//  DomainModule
//
//  Created by YoungK on 2023/02/22.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation
import RxSwift

public protocol FetchLyricsUseCase {
    func execute(id: String) -> Single<LyricsEntity>
}
