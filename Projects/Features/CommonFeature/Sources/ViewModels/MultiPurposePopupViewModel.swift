//
//  SearchViewModel.swift
//  SearchFeature
//
//  Created by yongbeomkwak on 2023/01/05.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import BaseDomainInterface
import BaseFeature
import Foundation
import PlayListDomainInterface
import RxRelay
import RxSwift
import UserDomainInterface
import Utility

public final class MultiPurposePopupViewModel: ViewModelType {
    var type: PurposeType
    var key: String
    let disposeBag: DisposeBag = DisposeBag()

    var createPlayListUseCase: CreatePlayListUseCase!
    var loadPlayListUseCase: LoadPlayListUseCase!
    var setUserNameUseCase: SetUserNameUseCase!
    var editPlayListNameUseCase: EditPlayListNameUseCase!

    public struct Input {
        let textString: BehaviorRelay<String> = BehaviorRelay(value: "")
        let pressConfirm: PublishSubject<Void> = PublishSubject()
    }

    public struct Output {
        let isFoucused: BehaviorRelay<Bool> = BehaviorRelay(value: false)
        let result: PublishSubject<BaseEntity> = PublishSubject()
        let newPlayListKey: PublishSubject<String> = PublishSubject()
    }

    public init(
        type: PurposeType,
        key: String,
        createPlayListUseCase: CreatePlayListUseCase,
        loadPlayListUseCase: LoadPlayListUseCase,
        setUserNameUseCase: SetUserNameUseCase,
        editPlayListNameUseCase: EditPlayListNameUseCase
    ) {
        self.key = key
        self.type = type
        self.createPlayListUseCase = createPlayListUseCase
        self.loadPlayListUseCase = loadPlayListUseCase
        self.setUserNameUseCase = setUserNameUseCase
        self.editPlayListNameUseCase = editPlayListNameUseCase
    }

    deinit {
        DEBUG_LOG("❌ \(Self.self) 소멸")
    }

    public func transform(from input: Input) -> Output {
        var output = Output()

        input.pressConfirm
            .withLatestFrom(input.textString)
            .subscribe(onNext: { [weak self] (text: String) in
                guard let self = self else {
                    return
                }
                switch self.type {
                case .creation:
                    self.createPlayListUseCase.execute(title: text)
                        .catch { (error: Error) in
                            let wmError = error.asWMError
                            if wmError == .tokenExpired {
                                return Single<PlayListBaseEntity>.create { single in
                                    single(.success(PlayListBaseEntity(
                                        status: 401,
                                        key: "",
                                        description: wmError.errorDescription ?? ""
                                    )))
                                    return Disposables.create()
                                }
                            } else {
                                return Single<PlayListBaseEntity>.create { single in
                                    single(.success(PlayListBaseEntity(
                                        status: 0,
                                        key: "",
                                        description: error.asWMError.errorDescription ?? ""
                                    )))
                                    return Disposables.create {}
                                }
                            }
                        }
                        .asObservable()
                        .map { entity -> (BaseEntity, String) in
                            return (BaseEntity(status: entity.status, description: entity.description), entity.key)
                        }
                        .subscribe(onNext: { (result: BaseEntity, key: String) in
                            if result.status != 200 { // Created == 201
                                output.result.onNext(result)
                                return
                            }
                            // 리프래쉬 작업
                            output.result.onNext(result)
                            output.newPlayListKey.onNext(key)
                            NotificationCenter.default.post(name: .playListRefresh, object: nil)
                        })
                        .disposed(by: self.disposeBag)

                case .nickname:
                    self.setUserNameUseCase.execute(name: text)
                        .catch { error in
                            let wmError = error.asWMError
                            if wmError == .tokenExpired {
                                return Single<BaseEntity>.create { single in
                                    single(.success(BaseEntity(
                                        status: 401,
                                        description: wmError.errorDescription ?? ""
                                    )))
                                    return Disposables.create()
                                }
                            } else {
                                return Single<BaseEntity>.create { single in
                                    single(.success(BaseEntity(
                                        status: 0,
                                        description: error.asWMError.errorDescription ?? ""
                                    )))
                                    return Disposables.create {}
                                }
                            }
                        }
                        .asObservable()
                        .subscribe(onNext: { result in
                            if result.status != 200 { // Created == 201
                                output.result.onNext(result)
                                return
                            }
                            Utility.PreferenceManager.userInfo = Utility.PreferenceManager.userInfo?
                                .update(displayName: AES256.encrypt(string: text))
                            output.result.onNext(BaseEntity(status: 200, description: ""))
                        }).disposed(by: self.disposeBag)

                case .load:
                    self.loadPlayListUseCase.execute(key: text)
                        .catch { (error: Error) in
                            let wmError = error.asWMError
                            if wmError == .tokenExpired {
                                return Single<PlayListBaseEntity>.create { single in
                                    single(.success(PlayListBaseEntity(
                                        status: 401,
                                        key: "",
                                        description: wmError.errorDescription ?? ""
                                    )))
                                    return Disposables.create()
                                }
                            } else {
                                return Single<PlayListBaseEntity>.create { single in
                                    single(.success(PlayListBaseEntity(
                                        status: 0,
                                        key: "",
                                        description: error.asWMError.errorDescription ?? ""
                                    )))
                                    return Disposables.create {}
                                }
                            }
                        }
                        .asObservable()
                        .map { entity -> BaseEntity in
                            return BaseEntity(status: entity.status, description: entity.description)
                        }
                        .subscribe(onNext: { result in
                            if result.status != 200 { // Created == 201
                                output.result.onNext(result)
                                return
                            }
                            // 리프래쉬 작업
                            NotificationCenter.default.post(name: .playListRefresh, object: nil)
                            output.result.onNext(result)
                        })
                        .disposed(by: self.disposeBag)

                case .edit:
                    self.editPlayListNameUseCase.execute(key: self.key, title: text)
                        .catch { (error: Error) in
                            let wmError = error.asWMError
                            if wmError == .tokenExpired {
                                return Single<EditPlayListNameEntity>.create { single in
                                    single(.success(EditPlayListNameEntity(
                                        title: "",
                                        status: 401,
                                        description: error.asWMError.errorDescription ?? ""
                                    )))
                                    return Disposables.create()
                                }
                            } else {
                                return Single<EditPlayListNameEntity>.create { single in
                                    single(.success(EditPlayListNameEntity(
                                        title: "",
                                        status: 0,
                                        description: error.asWMError.errorDescription ?? ""
                                    )))
                                    return Disposables.create {}
                                }
                            }
                        }
                        .asObservable()
                        .subscribe(onNext: { result in
                            if result.status != 200 {
                                output.result.onNext(BaseEntity(status: result.status, description: result.description))
                                return
                            }
                            NotificationCenter.default.post(name: .playListRefresh, object: nil) // 플리목록창 이름 변경하기 위함
                            NotificationCenter.default.post(name: .playListNameRefresh, object: result.title)
                            output.result.onNext(BaseEntity(status: 200, description: ""))
                        })
                        .disposed(by: self.disposeBag)

                case .share:
                    output.result.onNext(BaseEntity(status: 200, description: ""))
                }
            }).disposed(by: disposeBag)

        return output
    }
}
