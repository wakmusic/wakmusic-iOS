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
import ErrorModule

public final class ContainSongsViewModel: ViewModelType {
    var fetchPlayListUseCase:FetchPlayListUseCase!
    var addSongIntoPlayListUseCase:AddSongIntoPlayListUseCase!
    var songs:[String]!
    let disposeBag = DisposeBag()
    
    public struct Input {
        let newPlayListTap: PublishSubject<Void> = PublishSubject()
        let playListLoad: BehaviorRelay<Void> = BehaviorRelay(value: ())
        let containSongWithKey: PublishSubject<String> = PublishSubject()
    }
    
    public struct Output{
        let dataSource: BehaviorRelay<[PlayListEntity]> = BehaviorRelay(value: [])
        let showToastMessage: PublishSubject<String> = PublishSubject()
    }
    
    init(songs:[String],fetchPlayListUseCase: FetchPlayListUseCase!,addSongIntoPlayListUseCase:AddSongIntoPlayListUseCase!) {
        self.fetchPlayListUseCase = fetchPlayListUseCase
        self.addSongIntoPlayListUseCase = addSongIntoPlayListUseCase
        self.songs = songs
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
        
        input.containSongWithKey
            .flatMap({ [weak self] (key: String) -> Observable<AddSongEntity> in
                guard let self = self else {
                    return Observable.empty()
                }
                return self.addSongIntoPlayListUseCase
                    .execute(key: key, songs: self.songs)
                    .catchAndReturn(AddSongEntity(status: 500, added_songs_length: 0, duplicated: true))
                    .asObservable()
            })
            .map{ (entity: AddSongEntity) -> String in
                if entity.status == 500 {
                    return WMError.unknown.localizedDescription
                }else{
                    if entity.status == 200 {
                        if entity.duplicated {
                            return ("\(entity.added_songs_length)곡이 내 리스트에 담겼습니다. 중복 곡은 제외됩니다.")
                        }else {
                            return ("\(entity.added_songs_length)곡이 내 리스트에 담겼습니다.")
                        }
                    }else {
                        return ("이미 내 리스트에 담긴 곡들입니다.")
                    }
                }
            }
            .bind(to: output.showToastMessage)
            .disposed(by: disposeBag)
        
        return output
    }
}
