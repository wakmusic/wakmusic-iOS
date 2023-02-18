//
//  ArtistRepository.swift
//  DomainModule
//
//  Created by KTH on 2023/02/08.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation
import RxSwift
import DataMappingModule
import ErrorModule
import DomainModule

public protocol RemoteLikeDataSource {
    func fetchLikeNumOfSong(id:String) -> Single<FavoriteSongEntity>
    func addLikeSong(id:String) -> Single<BaseEntity>
    func cancelLikeSong(id:String) -> Single<BaseEntity>
  

}
