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


public enum SongRequestType {
    case add
    case edit
}

public final class AskSongViewModel:ViewModelType {

    var disposeBag = DisposeBag()
    var type: SongRequestType!
    
    public struct Input {
        var artistString:PublishRelay<String> = PublishRelay()
        var songTitleString:PublishRelay<String> = PublishRelay()
        var youtubeString:PublishRelay<String> = PublishRelay()
        var contentString:PublishRelay<String> = PublishRelay()
        var completionButtonTapped: PublishRelay<Void> = PublishRelay()
    }

    public struct Output {
        var enableCompleteButton: BehaviorRelay<Bool>
        var currentInputString: BehaviorRelay<(String, String, String, String)>
    }

    public init(type: SongRequestType){
        DEBUG_LOG("✅ \(Self.self) 생성")
        self.type = type
    }
    
    deinit {
        DEBUG_LOG("❌ \(Self.self) 소멸")
    }
    
    public func transform(from input: Input) -> Output {
        
        let enableCompleteButton: BehaviorRelay<Bool> = BehaviorRelay(value: false)
        let currentInputString: BehaviorRelay<(String, String, String, String)> = BehaviorRelay(value: ("", "", "", ""))

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
            .subscribe(onNext: { (artist, song, youtube, content) in
                //TO-DO: 여기를 고쳐서 api 연결하세요.
            }).disposed(by: disposeBag)
        
        combineObservable
            .bind(to: currentInputString)
            .disposed(by: disposeBag)
        
        return Output(
            enableCompleteButton: enableCompleteButton,
            currentInputString: currentInputString
        )
    }
}
