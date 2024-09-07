//
//  ArtistRepository.swift
//  DomainModule
//
//  Created by KTH on 2023/02/08.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation
import RxSwift

public protocol LikeRepository {
    func addLikeSong(id: String) -> Single<LikeEntity>
    func cancelLikeSong(id: String) -> Single<LikeEntity>
    func checkIsLikedSong(id: String) -> Single<Bool>
}
