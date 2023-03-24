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
import RxDataSources



public  final class AfterSearchContentViewModel:ViewModelType {
   
    


    
    var disposeBag = DisposeBag()
    var sectionType:TabPosition!
    var dataSource:[SearchSectionModel]

    
    
    public init(type:TabPosition,dataSource:[SearchSectionModel]){
        
        // AfterSearchContent 를 없애고 AfterSearch 쪽으로 들어감 
        print("✅ AfterSearchContentViewModel 생성")
        
        self.sectionType = type
        self.dataSource = dataSource
      
        
    }

    public struct Input {
        
        let indexPath:PublishRelay<IndexPath> = PublishRelay()
        
    }

    public struct Output {
        let dataSource:BehaviorRelay<[SearchSectionModel]> =  BehaviorRelay<[SearchSectionModel]>(value: [])
    }
    
    public func transform(from input: Input) -> Output {
        
        let output = Output()
        output.dataSource.accept(dataSource)
        
        
        input.indexPath
            .withLatestFrom(output.dataSource){($0,$1)}
            .map({[weak self] (indexPath,dataSource) -> [SearchSectionModel]  in
                
                guard let self = self else{return [] }
                
                let song = dataSource[indexPath.section].items[indexPath.row]
                
                
                NotificationCenter.default.post(name: .selectedSongOnSearch, object: (self.sectionType,song))
                
                
                var newModel = dataSource
                
               newModel[indexPath.section].items[indexPath.row].isSelected = !newModel[indexPath.section].items[indexPath.row].isSelected
                
                
                
                return newModel
            })
            .bind(to: output.dataSource)
            .disposed(by: disposeBag)
        
        
        
        
        
        
        return output
    }

}
