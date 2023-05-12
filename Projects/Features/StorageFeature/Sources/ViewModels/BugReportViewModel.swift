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
import Amplify

enum MediaDataType {
    case image(data: Data)
    case video(data: Data, url: URL)
}

enum PublicNameOption: String {
    case nonDetermined = "선택"
    case nonSigned = "가입안함"
    case `public` = "알려주기"
    case `private` = "비공개"
}

public final class BugReportViewModel:ViewModelType {
    var disposeBag = DisposeBag()
    var reportBugUseCase: ReportBugUseCase
    
    public struct Input {
        var publicNameOption:BehaviorRelay<PublicNameOption> = BehaviorRelay(value: .nonDetermined)
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
            input.publicNameOption,
            input.nickNameString,
            input.bugContentString
        ){
            return ($0, $1, $2)
        }

        combineObservable
            .map{ (option, nickName, content) -> Bool in
                switch option {
                case .nonDetermined:
                    return false
                case .nonSigned, .private:
                    return !content.isWhiteSpace
                case .public:
                    return !nickName.isWhiteSpace && !content.isWhiteSpace
                }
            }
            .bind(to: output.enableCompleteButton)
            .disposed(by: disposeBag)

        input.completionButtonTapped
            .withLatestFrom(input.dataSource)
            .flatMap{ (dataSource) -> Observable<[String]> in
                if dataSource.isEmpty {
                    return Observable.just([])
                }else{
                    let datas: [Data] = dataSource.map { (type) in
                        switch type {
                        case let .image(data):
                            return data
                        case let .video(data, _):
                            return data
                        }
                    }


                    let str = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
                    let size = 5
                    let iv = str.createRandomStr(length: size)

                    Task {
                        do {
                            let test = try await self.uploadImage(data: datas[0], fileName: iv)
                            DEBUG_LOG("URL: \(test)")
                        }catch {
                            DEBUG_LOG(error.localizedDescription)
                        }
                    }
//                    let stream = AsyncStream<Int> { continuation in
//                        Task.detached {
//                            let str = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
//                            let size = 5
//                            let iv = str.createRandomStr(length: size)
//                            for i in 0..<datas.count {
//                                do {
//                                    let test = try await self.uploadImage(data: datas[0], fileName: iv)
//                                    DEBUG_LOG("URL: \(test)")
//                                }catch {
//                                    DEBUG_LOG(error.localizedDescription)
//                                }
//                                continuation.yield(i)
//                            }
//                            continuation.finish()
//                        }
//                    }
//                    .asObservable()
                   
                    return Observable.just([])
                }
            }
            .withLatestFrom(combineObservable) { ($1.0, $1.1, $1.2, $0) }
            .flatMap({ [weak self] (option, nickName, content, urls) -> Observable<ReportBugEntity> in
                guard let self else { return Observable.empty() }
                let userId = AES256.decrypt(encoded: Utility.PreferenceManager.userInfo?.ID ?? "")
                return self.reportBugUseCase
                    .execute(userID: userId, nickname: option == .public ? nickName : "", attaches: [], content: content)
                    .debug("reportBugUseCase")
                    .catch({ (error:Error) in
                        return Single<ReportBugEntity>.create { single in
                            single(.success(ReportBugEntity(status: 404, message: error.asWMError.errorDescription ?? "")))
                            return Disposables.create {}
                        }
                    })
                    .asObservable()
                    .map{
                        ReportBugEntity(status: $0.status ,message: $0.message)
                    }
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
            .map{ (index,dataSource) -> [MediaDataType] in
                var next = dataSource
                next.remove(at: index)
                return next
            }
            .bind(to: input.dataSource)
            .disposed(by: disposeBag)
        
        return output
    }
}

extension BugReportViewModel {
    public func uploadImage(data: Data, fileName: String) async throws -> URL {
        let uploadTask = Amplify.Storage.uploadData(
            key: "\(fileName).jpg",
            data: data
        )
        Task {
            for await progress in await uploadTask.progress {
                DEBUG_LOG("Progress: \(progress)")
            }
        }
        let value = try await uploadTask.value
        DEBUG_LOG("Completed: \(value)")
        return try await getURL(fileName: fileName)
    }
    
    public func getURL(fileName: String) async throws -> URL {
       let url = try await Amplify.Storage.getURL(key: "\(fileName).jpg")
       if var components = URLComponents(string: url.absoluteString) {
           components.query = nil
           return components.url ?? url
       } else {
           return url
       }
    }
}
