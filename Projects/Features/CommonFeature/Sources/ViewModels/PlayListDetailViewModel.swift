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
import DataMappingModule
import Utility

struct PlayListHeaderInfo {
    var title:String
    var songCount:String
    var image:String
}


public final class PlayListDetailViewModel:ViewModelType {
   
    
    let input = Input()
    let output = Output()
    
    var type:PlayListType!
    var id:String!
    var fetchPlayListDetailUseCase:FetchPlayListDetailUseCase!
    var disposeBag = DisposeBag()

    public struct Input {
        let textString:BehaviorRelay<String> = BehaviorRelay(value: "")
        let sourceIndexPath:BehaviorRelay<IndexPath> = BehaviorRelay(value: IndexPath(row: 0, section: 0))
        let destIndexPath:BehaviorRelay<IndexPath> = BehaviorRelay(value: IndexPath(row: 0, section: 0))
        
        
    }

    public struct Output {
        let isEditinglist:BehaviorRelay<Bool> = BehaviorRelay(value:false)
        let headerInfo:PublishSubject<PlayListHeaderInfo> = PublishSubject()
        let dataSource:BehaviorRelay<[SongEntity]> = BehaviorRelay(value: [])
    }

    public init(id:String,type:PlayListType,fetchPlayListDetailUseCase:FetchPlayListDetailUseCase) {
        
        self.id = id
        self.type = type
        self.fetchPlayListDetailUseCase = fetchPlayListDetailUseCase
       
        DEBUG_LOG("✅ PlayListDetailViewModel 생성")
        
        
        fetchPlayListDetailUseCase.execute(id: id, type: type)
            //TODO: 에러 처리
            .asObservable()
            .do(onNext: { [weak self] (model) in
                
                guard let self = self else{
                    return
                }
                
                self.output.headerInfo.onNext(PlayListHeaderInfo(title: model.title, songCount: "\(model.songs.count)곡", image: type == .wmRecommend ? model.id : model.image ))
            })
            .map({$0.songs})
            .bind(to: output.dataSource)
            .disposed(by: disposeBag)
        
        
    }
    
    deinit{
        DEBUG_LOG("❌ PlayListDetailViewModel 소멸")
    }
    
    public func transform(from input: Input) -> Output {
        
        var output = Output()
        
        return output
    }
    
    
    
}
