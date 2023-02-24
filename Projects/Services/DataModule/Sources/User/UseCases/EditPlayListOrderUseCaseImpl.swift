//
//  FetchArtistListUseCaseImpl.swift
//  DataModule
//
//  Created by KTH on 2023/02/08.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation
import RxSwift
import DataMappingModule
import DomainModule
import ErrorModule

public struct EditPlayListOrderUseCaseImpl:EditPlayListOrderUseCase {
   
    
    

    private let userRepository: any UserRepository

    public init(
        userRepository: UserRepository
    ) {
        self.userRepository = userRepository
    }
    
    public func execute(ids: [String]) -> Single<BaseEntity> {
        userRepository.editPlayListOrder(ids: ids)
    }
 
 
    

   
}
