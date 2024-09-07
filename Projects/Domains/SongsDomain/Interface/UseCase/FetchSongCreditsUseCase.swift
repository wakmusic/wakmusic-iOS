//
//  FetchSongCreditsUseCase.swift
//  SongsDomain
//
//  Created by KTH on 5/14/24.
//  Copyright © 2024 yongbeomkwak. All rights reserved.
//

import Foundation
import RxSwift

public protocol FetchSongCreditsUseCase {
    func execute(id: String) -> Single<[SongCreditsEntity]>
}
