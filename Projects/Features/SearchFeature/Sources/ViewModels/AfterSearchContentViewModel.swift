//
//  SearchViewModel.swift
//  SearchFeature
//
//  Created by yongbeomkwak on 2023/01/05.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay
import BaseFeature
import DomainModule
import Utility

public enum SectionType:Int{
    case all = 0
    case song
    case artist
    case remix
}

public  final class AfterSearchContentViewModel:ViewModelType {
   
    

    let input = Input()
    let output = Output()
    
    var disposeBag = DisposeBag()
    var searchType:SectionType!
    var fetchSearchSongUseCase:FetchSearchSongUseCase!
    
    
    public init(type:SectionType,fetchSearchSongUseCase:FetchSearchSongUseCase){
        
        print("✅ AfterSearchContentViewModel 생성")
        
        self.searchType = type
        self.fetchSearchSongUseCase = fetchSearchSongUseCase
        
        
        fetchSearchSongUseCase.execute(type: .title, keyword: "리와인드")
            .subscribe(onSuccess: {DEBUG_LOG($0)})
            .disposed(by: disposeBag)
    }

    public struct Input {
        
        
    }

    public struct Output {
        let isFoucused:BehaviorRelay<Bool> = BehaviorRelay(value:false)
    }
    
    public func transform(from input: Input) -> Output {
        //hello
        let output = Output()
        
        
        return output
    }

}
