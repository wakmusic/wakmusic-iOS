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
        var showCollectionView: BehaviorRelay<Bool> = BehaviorRelay(value: true)
        var dataSource: BehaviorRelay<[MediaDataType]> = BehaviorRelay(value: [])
        var result: PublishSubject<ReportBugEntity>  = PublishSubject()
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
            .flatMap{ [weak self] (attaches) -> Observable<[String]> in
                guard let self = self else { return Observable.empty() }
                
                if attaches.isEmpty {
                    return Observable.just([])
                }else{
                    return AsyncStream<String> { continuation in
                        Task.detached {
                            for i in 0..<attaches.count {
                                do {
                                    let url = try await self.uploadImage(media: attaches[i])
                                    continuation.yield(url.absoluteString)
                                }catch {
                                    DEBUG_LOG(error.localizedDescription)
                                }
                            }
                            continuation.finish()
                        }
                    }
                    .asObservable()
                    .scan([]) { (pre, new) in
                        var result = pre
                        result.append(new)
                        return result
                    }.takeLast(1)
                }
            }
            .debug("uploadImage")
            .withLatestFrom(combineObservable) { ($1.0, $1.1, $1.2, $0) }
            .flatMap({ [weak self] (option, nickName, content, attaches) -> Observable<ReportBugEntity> in
                guard let self else { return Observable.empty() }
                let userId = AES256.decrypt(encoded: Utility.PreferenceManager.userInfo?.ID ?? "")
                return self.reportBugUseCase
                    .execute(userID: userId, nickname: (option == .public) ? nickName : "", attaches: attaches, content: content)
                    .debug("reportBugUseCase")
                    .catch({ (error:Error) in
                        return Single<ReportBugEntity>.create { single in
                            single(.success(ReportBugEntity(status: 404, message: error.asWMError.errorDescription ?? "")))
                            return Disposables.create {}
                        }
                    })
                    .asObservable()
                    .map{ (model) -> ReportBugEntity in
                        return ReportBugEntity(status: model.status ,message: model.message)
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
    private func uploadImage(media: MediaDataType) async throws -> URL {
        let str = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let size = 5
        let fileName = str.createRandomStr(length: size) + "_" + Date().dateToString(format: "yyyyMMddHHmmss")
        var data: Data?
        var ext: String = ""
        
        switch media {
        case let .image(model):
            data = model
            ext = "jpg"
        case let .video(model, _):
            data = model
            ext = "mp4"
        }

        let uploadTask = Amplify.Storage.uploadData(
            key: "\(fileName).\(ext)",
            data: data ?? Data()
        )
        Task {
            for await progress in await uploadTask.progress {
                DEBUG_LOG("Progress: \(progress)")
            }
        }
        let value = try await uploadTask.value
        DEBUG_LOG("Completed: \(value)")
        return try await getURL(fileName: fileName, ext: ext)
    }
    
    private func getURL(fileName: String, ext: String) async throws -> URL {
       let url = try await Amplify.Storage.getURL(key: "\(fileName).\(ext)")
       if var components = URLComponents(string: url.absoluteString) {
           components.query = nil
           return components.url ?? url
       } else {
           return url
       }
    }
}
