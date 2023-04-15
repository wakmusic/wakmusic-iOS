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

enum MediaDataType {
    case image(data: Data)
    case video(data: Data, url: URL)
    
    
    
}


public final class BugReportViewModel:ViewModelType {

    var disposeBag = DisposeBag()
    var reportBugUseCase: ReportBugUseCase
    
    public struct Input {
        var wakNickNameOption:BehaviorRelay<String> = BehaviorRelay(value: "선택")
        var bugContentString:PublishRelay<String> = PublishRelay()
        var nickNameString:PublishRelay<String> = PublishRelay()
        var completionButtonTapped: PublishSubject<Void> = PublishSubject()
        var dataSource:BehaviorRelay<[MediaDataType]> = BehaviorRelay(value: [])
        var removeIndex:PublishRelay<Int> = PublishRelay()
    }

    public struct Output {
        var enableCompleteButton: BehaviorRelay<Bool> = BehaviorRelay(value: false)
        var showCollectionView:BehaviorRelay<Bool> = BehaviorRelay(value: true)
        var dataSource:BehaviorRelay<[MediaDataType]> = BehaviorRelay(value: [])
        var result:PublishSubject<ReportBugEntity>  = PublishSubject()
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
            input.bugContentString,
            input.dataSource

        ){
            return ($0, $1, $2,$3)
        }

        combineObservable
            .map { return $0.0.description == "선택" ? false: $0.0.description == "알려주기" ?
                !$0.1.isWhiteSpace && !$0.2.isWhiteSpace : !$0.2.isWhiteSpace }
            .bind(to: output.enableCompleteButton)
            .disposed(by: disposeBag)

        input.completionButtonTapped
            .withLatestFrom(combineObservable)
            .debug("FFFF")
            .flatMap({ [weak self] (option, nickName, content,dataSource) -> Observable<ReportBugEntity> in
                
                
                guard let self else { return Observable.empty()}
                
                let userId = AES256.decrypt(encoded: Utility.PreferenceManager.userInfo?.ID ?? "")
                
                var datas: [Data] = dataSource.map { (type) in
                            switch type {
                            case let .image(data):
                                return data
                            case let .video(data, _):
                                return data
                            }
                    }
                
                
                return self.reportBugUseCase
                    .execute(userID: userId, nickname: option == "알려주기" ? nickName : "", attaches:datas, content: content)
                    .catch({ (error:Error) in
                        return Single<ReportBugEntity>.create { single in
                            single(.success(ReportBugEntity(status: 404, message: error.asWMError.errorDescription ?? "")))
                            return Disposables.create {}
                        }
                    })
                    .asObservable()
                    .map({
                        ReportBugEntity(status: $0.status ,message: $0.message)
                    })
                
                
            })
            .bind(to: output.result)
            .disposed(by: disposeBag)

        
        input.dataSource
            .bind(to: output.dataSource)
            .disposed(by: disposeBag)
        
        
        input.dataSource
            .map({$0.isEmpty})
            .bind(to: output.showCollectionView)
            .disposed(by: disposeBag)
        
        
        input.removeIndex
            .withLatestFrom(input.dataSource){($0,$1)}
            .map({(index,dataSource) -> [MediaDataType] in
                
               var next = dataSource
                
                next.remove(at: index)
                
                return next
            })
            .bind(to: input.dataSource)
            .disposed(by: disposeBag)
        
        return output
    }
}
