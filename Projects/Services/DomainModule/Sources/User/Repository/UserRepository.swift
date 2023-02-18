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

public protocol UserRepository {
    func setProfile(token:String,image:String) -> Completable
    func setUserName(token:String,name:String) -> Completable

}
