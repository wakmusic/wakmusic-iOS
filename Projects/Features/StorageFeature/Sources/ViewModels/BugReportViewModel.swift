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
    var reportBugUseCase: ReportBugUseCase
    
    public struct Input {
        var wakNickNameOption:BehaviorRelay<String> = BehaviorRelay(value: "선택")
        var bugContentString:PublishRelay<String> = PublishRelay()
        var nickNameString:PublishRelay<String> = PublishRelay()
        var completionButtonTapped: PublishRelay<Void> = PublishRelay()
    }

    public struct Output {
        var enableCompleteButton: BehaviorRelay<Bool> = BehaviorRelay(value: false)
        var showCollectionView:BehaviorRelay<Bool> = BehaviorRelay(value: true)
    }

    public init(reportBugUseCase: ReportBugUseCase){
        self.reportBugUseCase = reportBugUseCase
    }
    
    deinit {
        DEBUG_LOG("❌ \(Self.self) 소멸")
    }
    
    public func transform(from input: Input) -> Output {
        
        let output = Output()

        let combineObservable = Observable.combineLatest(
            input.wakNickNameOption,
            input.nickNameString,
            input.bugContentString

        ){
            return ($0, $1, $2)
        }

        combineObservable
            .map { return $0.0.description == "선택" ? false: $0.0.description == "알려주기" ?
                !$0.1.isWhiteSpace && !$0.2.isWhiteSpace : !$0.2.isWhiteSpace }
            .bind(to: output.enableCompleteButton)
            .disposed(by: disposeBag)

        input.completionButtonTapped
            .withLatestFrom(combineObservable)
            .subscribe(onNext: { (option, nickName, content) in
                //TO-DO: 여기를 고쳐서 api 연결하세요.
            }).disposed(by: disposeBag)

        
        return output
    }
}
