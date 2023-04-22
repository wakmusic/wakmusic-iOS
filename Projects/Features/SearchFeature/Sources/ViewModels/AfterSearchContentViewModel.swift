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
        DEBUG_LOG("✅ AfterSearchContentViewModel 생성")
        
        self.sectionType = type
        self.dataSource = dataSource
      
        
    }

    public struct Input {
        
        let indexPath:PublishRelay<IndexPath> = PublishRelay()
        let mandatoryLoadIndexPath:PublishRelay<[IndexPath]> = PublishRelay()
        let deSelectedAllSongs:PublishRelay<Void> = PublishRelay()
        
    }

    public struct Output {
        let dataSource:BehaviorRelay<[SearchSectionModel]> =  BehaviorRelay<[SearchSectionModel]>(value: [])
    }
    
    public func transform(from input: Input) -> Output {
        
        let output = Output()
        output.dataSource.accept(dataSource)
        
        
        
        input.mandatoryLoadIndexPath
            .withLatestFrom(output.dataSource) {($0,$1)}
            .map({ (indexPathes,dataSource) -> [SearchSectionModel] in
                
                var newModel = dataSource
                
                
                for indexPath in indexPathes {
                    
                    newModel[indexPath.section].items[indexPath.row].isSelected = true
                    
                }
                
                return newModel
            })
            .bind(to: output.dataSource)
            .disposed(by: disposeBag)
     
        
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
        
        
        NotificationCenter.default.rx.notification(.selectedSongOnSearch)
            .filter({ [weak self]  in
                
                guard let self = self else{return false}
                
                
                guard let result = $0.object as? (TabPosition,SongEntity) else {
                    return false
                }
                
                
                return self.sectionType != result.0
            })
            .map({(res) -> SongEntity  in
                
            
                
                
                guard let result = res.object as? (TabPosition,SongEntity) else {
                    return SongEntity(id: "-", title: "", artist: "", remix: "", reaction: "", views: 0, last: 0, date: "")
                }
                
                return result.1
            })
            .filter({$0.id != "-"})
            .withLatestFrom(output.dataSource){($0,$1)}
            .map{ (song: SongEntity, dataSource: [SearchSectionModel]) -> [SearchSectionModel] in
                var indexPath:IndexPath = IndexPath(row: -1, section: 0) // 비어있는 탭 예외 처리
                var models = dataSource
                
                models.enumerated().forEach { (section, model) in
                    if let row = model.items.firstIndex(where: { $0 == song }){
                        indexPath = IndexPath(row: row, section: section)
                    }
                }
                
                guard indexPath.row >= 0 else { // 비어있는 탭 예외 처리
                    return models
                }
                
                models[indexPath.section].items[indexPath.row].isSelected = !models[indexPath.section].items[indexPath.row].isSelected
                return models
            }
            .bind(to: output.dataSource)
            .disposed(by: disposeBag)
        
        input.deSelectedAllSongs
            .withLatestFrom(output.dataSource)
            .map({(dataSource) -> [SearchSectionModel] in
               return dataSource.map { sectionModel -> SearchSectionModel in
                            var newItems = sectionModel.items
                            newItems.indices.forEach { newItems[$0].isSelected = false }
                   return SearchSectionModel(model: sectionModel.model, items: newItems)
                }
            })
            .bind(to: output.dataSource)
            .disposed(by: disposeBag)
        
        return output
    }

}
