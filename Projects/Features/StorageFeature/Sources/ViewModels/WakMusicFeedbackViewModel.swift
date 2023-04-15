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

public final class WakMusicFeedbackViewModel:ViewModelType {

    var disposeBag = DisposeBag()
    var inquiryWeeklyChartUseCase: InquiryWeeklyChartUseCase
    
    public struct Input {
        var textString:PublishRelay<String> = PublishRelay()
        var completionButtonTapped: PublishSubject<Void> = PublishSubject()
    }

    public struct Output {
        var result:PublishSubject<InquiryWeeklyChartEntity> = PublishSubject()
    }

    public init(
        inquiryWeeklyChartUseCase: InquiryWeeklyChartUseCase
    ) {
        self.inquiryWeeklyChartUseCase = inquiryWeeklyChartUseCase
    }
    
    deinit {
        DEBUG_LOG("❌ \(Self.self) 소멸")
    }
    
    public func transform(from input: Input) -> Output {
        let output = Output()
        
        input.completionButtonTapped
            .withLatestFrom(input.textString)
            .debug("completionButtonTapped")
            .flatMap({ [weak self] (content) -> Observable<InquiryWeeklyChartEntity> in
                guard let self else {return Observable.empty()}
                let userId = AES256.decrypt(encoded: Utility.PreferenceManager.userInfo?.ID ?? "")
                
                return self.inquiryWeeklyChartUseCase.execute(userID: userId, content: content)
                    .catch({ (error:Error) in
                        return Single<InquiryWeeklyChartEntity>.create { single in
                            single(.success(InquiryWeeklyChartEntity(status: 404, message: error.asWMError.errorDescription ?? "")))
                            return Disposables.create {}
                        }
                    })
                    .asObservable()
                    .map{
                        InquiryWeeklyChartEntity(status: $0.status ,message: $0.message)
                    }
            })
            .bind(to: output.result)
            .disposed(by: disposeBag)
        
        return output
    }
}
