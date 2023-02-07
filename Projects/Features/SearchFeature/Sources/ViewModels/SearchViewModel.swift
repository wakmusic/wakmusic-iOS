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

public  final class SearchViewModel:ViewModelType {
   
    

    let input = Input()
    let output = Output()
    var disposeBag = DisposeBag()
    var fetchSearchSongUseCase:FetchSearchSongUseCase
    
    public init(
        fetchSearchSongUseCase: any FetchSearchSongUseCase
    ){
        self.fetchSearchSongUseCase = fetchSearchSongUseCase
        
        print("✅ SearchViewModel 생성")
        
        fetchSearchSongUseCase.execute(type: .title, keyword: "리와인드")
            .subscribe(onSuccess: { (res:[SearchEntity]) in
                DEBUG_LOG("RESULT \(res)")
            }).disposed(by: disposeBag)
    }

    public struct Input {
        let textString:BehaviorRelay<String> = BehaviorRelay(value: "")
        
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
