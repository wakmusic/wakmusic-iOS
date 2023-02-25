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
    var key:String?
    var fetchPlayListDetailUseCase:FetchPlayListDetailUseCase!
    var disposeBag = DisposeBag()

    public struct Input {
        let textString:BehaviorRelay<String> = BehaviorRelay(value: "")
        let sourceIndexPath:BehaviorRelay<IndexPath> = BehaviorRelay(value: IndexPath(row: 0, section: 0))
        let destIndexPath:BehaviorRelay<IndexPath> = BehaviorRelay(value: IndexPath(row: 0, section: 0))
        let showErrorToast:PublishRelay<String> = PublishRelay()
        let playListNameLoad:BehaviorRelay<String> = BehaviorRelay(value: "")
        
    }

    public struct Output {
        let isEditing:BehaviorRelay<EditState> = BehaviorRelay(value:EditState(isEditing: false, force: false))
        let headerInfo:PublishRelay<PlayListHeaderInfo> = PublishRelay()
        let dataSource:BehaviorRelay<[SongEntity]> = BehaviorRelay(value: [])
        let backUpdataSource:BehaviorRelay<[SongEntity]> = BehaviorRelay(value: [])
    }

    public init(id:String,type:PlayListType,fetchPlayListDetailUseCase:FetchPlayListDetailUseCase) {
        
        self.id = id
        self.type = type
        self.fetchPlayListDetailUseCase = fetchPlayListDetailUseCase
       
        DEBUG_LOG("✅ PlayListDetailViewModel 생성")
        
        
        fetchPlayListDetailUseCase.execute(id: id, type: type)
            .asObservable()
            .do(onNext: { [weak self] (model) in
                
                guard let self = self else{
                    return
                }
                
                
                self.output.headerInfo.accept(PlayListHeaderInfo(title: model.title, songCount: "\(model.songs.count)곡", image: type == .wmRecommend ? model.id : model.image))
                
                self.key = model.key
            })
            .map({$0.songs})
                .bind(to: output.dataSource,output.backUpdataSource)
            .disposed(by: disposeBag)
                
            
            input.playListNameLoad
                .skip(1)
                .withLatestFrom(output.headerInfo){($0,$1)}
                .map({PlayListHeaderInfo(title: $0.0, songCount: $0.1.songCount, image: $0.1.image)})
                .bind(to: output.headerInfo)
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
