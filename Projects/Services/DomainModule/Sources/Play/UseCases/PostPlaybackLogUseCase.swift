//
//  PostPlaybackLogUseCase.swift
//  DomainModuleTests
//
//  Created by KTH on 2023/08/27.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation
import RxSwift
import DataMappingModule

public protocol PostPlaybackLogUseCase {
    func execute(item: Data) -> Single<PlaybackLogEntity>
}
