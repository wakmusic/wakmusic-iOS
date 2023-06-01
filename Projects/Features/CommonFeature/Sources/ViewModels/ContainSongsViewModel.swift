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
        let showToastMessage: PublishSubject<AddSongEntity> = PublishSubject()
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
                    .catch{ (error: Error) in
                        let wmError = error.asWMError
                        if wmError == .tokenExpired {
                            let model = AddSongEntity(
                                status: 401,
                                added_songs_length: 0,
                                duplicated: false,
                                description: wmError.errorDescription ?? ""
                            )
                            output.showToastMessage.onNext(model)
                        }
                        return Observable.just([])
                    }
                // //@구구 플레이리스트 가져올 때  만료 처리 부탁드립니다.
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
                    .catch({ (error:Error) in
                        
                        let wmError = error.asWMError
                        
                        if wmError == .tokenExpired {
                            return Single<AddSongEntity>.create { single in
                                single(.success(AddSongEntity(status: 401,added_songs_length: 0, duplicated:false, description:  wmError.errorDescription ?? "")))
                                return Disposables.create()
                            }
                        }
                        
                        else if wmError == .badRequest {
                            return Single<AddSongEntity>.create { single in
                                single(.success(AddSongEntity(status: 400,added_songs_length: 0, duplicated:true, description:"이미 내 리스트에 담긴 곡들입니다.")))
                                return Disposables.create {}
                            }
                        }
                        
                        else  {
                            return Single<AddSongEntity>.create { single in
                                single(.success(AddSongEntity(status: 500,added_songs_length: 0, duplicated:false, description:"서버에서 문제가 발생하였습니다.\n잠시 후 다시 시도해주세요!")))
                                return Disposables.create {}
                            }
                        }
                        
                    })
                    .asObservable()
            })
            .map{ (entity: AddSongEntity) -> AddSongEntity in
                if entity.status == 200 {
                    if entity.duplicated {
                        return  AddSongEntity(status: 200, added_songs_length: entity.added_songs_length, duplicated: true, description: "\(entity.added_songs_length)곡이 내 리스트에 담겼습니다. 중복 곡은 제외됩니다." )
                    }else {
                        return  AddSongEntity(status: 200, added_songs_length: entity.added_songs_length, duplicated: false, description: "\(entity.added_songs_length)곡이 내 리스트에 담겼습니다.")
                    }
                }
                else {
                    return entity
                }
            }
            .bind(to: output.showToastMessage)
            .disposed(by: disposeBag)
        
        return output
    }
}
