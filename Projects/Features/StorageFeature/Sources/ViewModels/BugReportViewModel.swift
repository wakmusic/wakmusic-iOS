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


public final class BugReportViewModel:ViewModelType {

    var disposeBag = DisposeBag()
    
    public struct Input {
        var wakNickNameOption:BehaviorRelay<String> = BehaviorRelay(value: "알려주기")
        var bugContentString:PublishRelay<String> = PublishRelay()
        var nickNameString:PublishRelay<String> = PublishRelay()
        var completionButtonTapped: PublishRelay<Void> = PublishRelay()
        
    }

    public struct Output {
        var enableCompleteButton: BehaviorRelay<Bool> = BehaviorRelay(value: false)
        var showCollectionView:BehaviorRelay<Bool> = BehaviorRelay(value: true)
    }

    public init(){
        DEBUG_LOG("✅ \(Self.self) 생성")
    }
    
    deinit {
        DEBUG_LOG("❌ \(Self.self) 소멸")
    }
    
    public func transform(from input: Input) -> Output {
        
        let output = Output()

//        let combineObservable = Observable.combineLatest(
//            input.artistString,
//            input.songTitleString,
//            input.youtubeString,
//            input.contentString
//        ){
//            return ($0, $1, $2, $3)
//        }
//
//        combineObservable
//            .debug("askSong combine")
//            .map { return !($0.isWhiteSpace || $1.isWhiteSpace || $2.isWhiteSpace || $3.isWhiteSpace) }
//            .bind(to: enableCompleteButton)
//            .disposed(by: disposeBag)
//
//        input.completionButtonTapped
//            .withLatestFrom(combineObservable)
//            .debug("completionButtonTapped")
//            .subscribe(onNext: { (artist, song, youtube, content) in
//                //TO-DO: 여기를 고쳐서 api 연결하세요.
//            }).disposed(by: disposeBag)
//
        
        return output
    }
}
