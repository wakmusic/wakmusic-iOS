//
//  FetchArtistListUseCase.swift
//  DomainModule
//
//  Created by KTH on 2023/02/08.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import BaseDomainInterface
import Foundation
import RxSwift

public protocol SetProfileUseCase {
    func execute(image: String) -> Single<BaseEntity>
}
