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



public final class AfterSearchViewModel:ViewModelType {
   
    


    
    var disposeBag = DisposeBag()
    var fetchSearchSongUseCase:FetchSearchSongUseCase!
    
    public init(fetchSearchSongUseCase:FetchSearchSongUseCase){
        
        print("✅ AfterSearchViewModel 생성")
        self.fetchSearchSongUseCase = fetchSearchSongUseCase
        
        

        
        
        
        
    }

    public struct Input {
        let text:BehaviorRelay<String> = BehaviorRelay<String>(value: "")
        
    }

    public struct Output {
        
        let result:BehaviorRelay<[SearchSectionModel]> = BehaviorRelay<[SearchSectionModel]>(value: [])
    }
    
    public func transform(from input: Input) -> Output {
        //hello
        let output = Output()
        
        
        let zip = Observable.zip(fetchSearchSongUseCase.execute(type: .title, keyword: "리와인드").asObservable(), fetchSearchSongUseCase.execute(type: .artist, keyword: "리와인드").asObservable())
        let remix = fetchSearchSongUseCase.execute(type: .remix, keyword: "리와인드").asObservable()
        
        
        let reuslt = Observable.zip(zip, remix)
        
        reuslt.map{ [weak self] (res,r3) in
            
            let (r1, r2) = res
        
            let tmp : [SearchSectionModel] = [SearchSectionModel(model: .song, items: r1)] + [SearchSectionModel(model: .artist, items: r2)] + [SearchSectionModel(model: .remix, items: r3)]
            
            
            return tmp
        }.bind(to: output.result)
            .disposed(by: disposeBag)
    
        
        
        
        
        return output
    }

}
