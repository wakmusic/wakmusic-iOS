//
//  ContainSongsViewModel.swift
//  CommonFeature
//
//  Created by yongbeomkwak on 2023/03/11.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation
import BaseFeature
import RxRelay
import DomainModule
import RxSwift

public final class ContainSongsViewModel:ViewModelType {

    
    
    var fetchPlayListUseCase:FetchPlayListUseCase!
    var addSongIntoPlayListUseCase:AddSongIntoPlayListUseCase!
    
    let disposeBag = DisposeBag()
    
    public struct Input {
        
        let newPlayListTap:PublishSubject<Void> = PublishSubject()
        let playListLoad:BehaviorRelay<Void> = BehaviorRelay(value: ())
        
    }
    
    public struct Output{
        let dataSource: BehaviorRelay<[PlayListEntity]> = BehaviorRelay(value: [])
        let containSongWithKey: PublishSubject<String> = PublishSubject()
        let showToastMessage: PublishSubject<String> = PublishSubject()
    }
    
    init(fetchPlayListUseCase: FetchPlayListUseCase!,addSongIntoPlayListUseCase:AddSongIntoPlayListUseCase!) {
        self.fetchPlayListUseCase = fetchPlayListUseCase
        self.addSongIntoPlayListUseCase = addSongIntoPlayListUseCase
        
        
    }
    
    public func transform(from input: Input) -> Output {
        
        let output = Output()
        
        
        
        
        input.playListLoad
            .flatMap({ [weak self] () -> Observable<[PlayListEntity]> in

                guard let self = self else{
                    return Observable.empty()
                }
                
        

                return self.fetchPlayListUseCase.execute()
                    .asObservable()
                    .catchAndReturn([])
            })
            .bind(to: output.dataSource)
            .disposed(by: disposeBag)
        
        output.containSongWithKey
            .flatMap({ [weak self] (key:String) -> Observable<AddSongEntity> in
                
                let tmpSongs = ["1UbyyaDc8x0",
                                "C1dSgetEBPM",
                                "OTkFJyn4mvc",
                                "fU8picIMbSk",
                                "Empfi8q0aas",
                                "l8e1Byk1Dx0",
                                "rFxJjpSeXHI",
                                "K8WC6uWyC9I",
                                "08meo6qrhFc",
                                "6hEvgKL0ClA",
                                "wSG93VZoMFg"
                ]
                
                guard let self = self else {
                    return Observable.empty()
                }
                
                
                return self.addSongIntoPlayListUseCase.execute(key: key, songs: tmpSongs)
                        .catchAndReturn(AddSongEntity(status: 400, added_songs_length: 0, duplicated: true))
                        .asObservable()
            })
            .flatMap({ (entity:AddSongEntity) -> Observable<String> in
                
                if entity.status == 200 {
                    
                    if entity.duplicated {
                        return Observable.just("\(entity.added_songs_length)곡이 플레이리스트에 담겼습니다. 중복 곡은 제외됩니다.")
                    }
                    
                    else {
                        return Observable.just("\(entity.added_songs_length)곡이 플레이리스트에 담겼습니다.")
                    }
                    
                    
                }
                else {
                    return Observable.just(" 이미 플레이리스트에 담긴 곡들입니다.")
                }
                
            })
            .bind(to: output.showToastMessage)
            .disposed(by: disposeBag)
        
        
        return output
    }
    
    
}
