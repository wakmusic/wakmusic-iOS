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
        
        let result:BehaviorRelay<[[SearchSectionModel]]> = BehaviorRelay<[[SearchSectionModel]]>(value: [])
        
    }
    
    public func transform(from input: Input) -> Output {
        //hello
        let output = Output()

        input.text
            .filter({!$0.isEmpty}) //빈 것에 대한 예외 처리
            .flatMap { [weak self] (str:String) -> Observable<(([SongEntity], [SongEntity]), [SongEntity])> in
                
                guard let self = self else{
                    return Observable.empty()
                }
                
                let zip = Observable.zip(self.fetchSearchSongUseCase.execute(type: .title, keyword: str).asObservable(), self.fetchSearchSongUseCase.execute(type: .artist, keyword: str).asObservable())
                let remix = self.fetchSearchSongUseCase.execute(type: .remix, keyword: str).asObservable()
                
                let result = Observable.zip(zip, remix)
                
                return result
            }
            .map{ [weak self] (res,r3) in
            
            var results:[[SearchSectionModel]] = []
            
            
            let (r1, r2) = res
            
            var all: [SearchSectionModel] = []
            
            if !r1.isEmpty && ( r2.isEmpty && r3.isEmpty ) {
                    all =    [
                        SearchSectionModel(model: (.song,r1.count), items: r1 ),

                ]
            }
            
            else if !r2.isEmpty && ( r1.isEmpty && r3.isEmpty ) {
                    all =    [
                    SearchSectionModel(model: (.artist,r2.count), items: r2 ),

                ]
            }
            
            else if !r3.isEmpty && ( r1.isEmpty && r2.isEmpty ) {
                    all =    [
                    SearchSectionModel(model: (.remix,r3.count), items: r3 ),

                ]
            }
            
            else {
                
                all  = [
                    SearchSectionModel(model: (.song,r1.count), items: r1.count > 3 ? Array(r1[0...2]) : r1 ),
                    SearchSectionModel(model: (.artist,r2.count), items: r2.count > 3 ? Array(r2[0...2]) : r2 ),
                    SearchSectionModel(model: (.remix,r3.count), items: r3.count > 3 ? Array(r3[0...2]) : r3 )
                
                ]
                
            }
            

            results.append(all)
            results.append([SearchSectionModel(model: (.song,r1.count), items: r1)])
            results.append([SearchSectionModel(model: (.artist,r2.count), items: r2)])
            results.append([SearchSectionModel(model: (.remix,r3.count), items: r3)])
            

            return results
        }.bind(to: output.result)
            .disposed(by: disposeBag)
    
        
        
        
        
        return output
    }

}
