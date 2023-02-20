//
//  HomeRepository.swift
//  DomainModule
//
//  Created by KTH on 2023/02/20.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import DataMappingModule
import ErrorModule
import Foundation
import RxSwift

public protocol HomeRepository {
    func fetchNewSong(type: NewSongGroupType) -> Single<[NewSongEntity]>
}
