//
//  AfterLoginStorageViewModel.swift
//  StorageFeature
//
//  Created by yongbeomkwak on 2023/01/26.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation
import Utility
import RxSwift
import RxRelay
import DomainModule
import BaseFeature
import KeychainModule
import DataMappingModule

public final class AskSongViewModel:ViewModelType {

    var disposeBag = DisposeBag()
    var type: SuggestSongModifyType!
    var modifySongUseCase: ModifySongUseCase
    
    public struct Input {
        var artistString:PublishRelay<String> = PublishRelay()
        var songTitleString:PublishRelay<String> = PublishRelay()
        var youtubeString:PublishRelay<String> = PublishRelay()
        var contentString:PublishRelay<String> = PublishRelay()
        var completionButtonTapped: PublishSubject<Void> = PublishSubject()
    }

    public struct Output {
        var enableCompleteButton: BehaviorRelay<Bool>
        var result:PublishSubject<ModifySongEntity>
    }

    public init(type: SuggestSongModifyType, modifySongUseCase: ModifySongUseCase){
        self.type = type
        self.modifySongUseCase = modifySongUseCase
    }
    
    deinit {
        DEBUG_LOG("❌ \(Self.self) 소멸")
    }
    
    public func transform(from input: Input) -> Output {
        
        let enableCompleteButton: BehaviorRelay<Bool> = BehaviorRelay(value: false)
        let result:PublishSubject<ModifySongEntity> = PublishSubject()
        
        let combineObservable = Observable.combineLatest(
            input.artistString,
            input.songTitleString,
            input.youtubeString,
            input.contentString
        ){
            return ($0, $1, $2, $3)
        }

        combineObservable
            .debug("askSong combine")
            .map { return !($0.isWhiteSpace || $1.isWhiteSpace || $2.isWhiteSpace || $3.isWhiteSpace) }
            .bind(to: enableCompleteButton)
            .disposed(by: disposeBag)
        
        input.completionButtonTapped
            .withLatestFrom(combineObservable)
            .debug("completionButtonTapped")
            .flatMap({ [weak self] (artist, song, youtube, content) -> Observable<ModifySongEntity> in
                guard let self else {return Observable.empty()}
                let userId = AES256.decrypt(encoded: Utility.PreferenceManager.userInfo?.ID ?? "")
                
                return self.modifySongUseCase.execute(type: self.type, userID: userId, artist: artist, songTitle: song, youtubeLink: youtube, content: content)
                    .catch({ (error:Error) in
                        return Single<ModifySongEntity>.create { single in
                            single(.success(ModifySongEntity(status: 404, message: error.asWMError.errorDescription ?? "")))
                            return Disposables.create {}
                        }
                    })
                    .asObservable()
                    .map{
                        ModifySongEntity(status: $0.status ,message: $0.message)
                    }
            })
            .bind(to: result)
            .disposed(by: disposeBag)

        return Output(
            enableCompleteButton: enableCompleteButton,
            result: result
        )
    }
}
