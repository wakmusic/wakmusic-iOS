//
//  PostPlaybackLogUseCase.swift
//  DomainModuleTests
//
//  Created by KTH on 2023/08/27.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import DataMappingModule
import Foundation
import RxSwift

public protocol PostPlaybackLogUseCase {
    func execute(item: Data) -> Single<PlaybackLogEntity>
}
