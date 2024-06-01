import AuthDomainInterface
import BaseDomainInterface
import BaseFeatureInterface
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
    // TODO: 플레이리스트 이름 변경 Usecase
    private let logoutUseCase: any LogoutUseCase

    public struct Input {
        let textString: BehaviorRelay<String> = BehaviorRelay(value: "")
        let pressConfirm: PublishSubject<Void> = PublishSubject()
    }

    public struct Output {
        let isFoucused: BehaviorRelay<Bool> = BehaviorRelay(value: false)
        let result: PublishSubject<BaseEntity> = PublishSubject()
        let newPlayListKey: PublishSubject<String> = PublishSubject()
        let onLogout: PublishRelay<Error>
    }

    public init(
        type: PurposeType,
        key: String,
        createPlayListUseCase: CreatePlayListUseCase,
        loadPlayListUseCase: LoadPlayListUseCase,
        setUserNameUseCase: SetUserNameUseCase,
        logoutUseCase: any LogoutUseCase
    ) {
        self.key = key
        self.type = type
        self.createPlayListUseCase = createPlayListUseCase
        self.loadPlayListUseCase = loadPlayListUseCase
        self.setUserNameUseCase = setUserNameUseCase
        self.logoutUseCase = logoutUseCase
    }

    deinit {
        DEBUG_LOG("❌ \(Self.self) 소멸")
    }

    public func transform(from input: Input) -> Output {
        let logoutRelay = PublishRelay<Error>()

        var output = Output(
            onLogout: logoutRelay
        )

        input.pressConfirm
            .withLatestFrom(input.textString)
            .subscribe(onNext: { [weak self, logoutUseCase] (text: String) in
                guard let self = self else {
                    return
                }
                switch self.type {
                case .creation:
                    self.createPlayListUseCase.execute(title: text)
                        .catch { (error: Error) in
                            let wmError = error.asWMError
                            if wmError == .tokenExpired {
                                logoutRelay.accept(error)
                                return logoutUseCase.execute()
                                    .andThen(.never())
                            } else {
                                output.result.onNext(BaseEntity(
                                    status: 400,
                                    description: wmError.asWMError.errorDescription ?? ""
                                ))
                                return .never()
                            }
                        }
                        .asObservable()
                        .subscribe(onNext: { _ in
                            output.result.onNext(BaseEntity(status: 200, description: ""))
                            NotificationCenter.default.post(name: .playListRefresh, object: nil)
                        })
                        .disposed(by: self.disposeBag)

                case .nickname:
                    self.setUserNameUseCase.execute(name: text)
                        .catch { error in
                            let wmError = error.asWMError
                            if wmError == .tokenExpired {
                                logoutRelay.accept(error)
                                return logoutUseCase.execute()
                                    .andThen(.never())
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
                                logoutRelay.accept(error)
                                return logoutUseCase.execute()
                                    .andThen(.never())
                            } else {
                                output.result.onNext(BaseEntity(
                                    status: 400,
                                    description: wmError.asWMError.errorDescription ?? ""
                                ))
                                return .never()
                            }
                        }
                        .asObservable()
                        .subscribe(onNext: { _ in
                            output.result.onNext(BaseEntity(status: 200, description: ""))
                            NotificationCenter.default.post(name: .playListRefresh, object: nil)
                        })
                        .disposed(by: self.disposeBag)

                case .edit:
                    break
//                    self.editPlayListNameUseCase.execute(key: self.key, title: text)
//                        .catch { (error: Error) in
//                            let wmError = error.asWMError
//                            if wmError == .tokenExpired {
//                                logoutRelay.accept(error)
//                                return logoutUseCase.execute()
//                                    .andThen(.never())
//                            } else {
//                                return Single<EditPlayListNameEntity>.create { single in
//                                    single(.success(EditPlayListNameEntity(
//                                        title: "",
//                                        status: 0,
//                                        description: error.asWMError.errorDescription ?? ""
//                                    )))
//                                    return Disposables.create {}
//                                }
//                            }
//                        }
//                        .asObservable()
//                        .subscribe(onNext: { result in
//                            if result.status != 200 {
//                                output.result.onNext(BaseEntity(status: result.status, description: result.description))
//                                return
//                            }
//                            NotificationCenter.default.post(name: .playListRefresh, object: nil) // 플리목록창 이름 변경하기 위함
//                            NotificationCenter.default.post(name: .playListNameRefresh, object: result.title)
//                            output.result.onNext(BaseEntity(status: 200, description: ""))
//                        })
//                        .disposed(by: self.disposeBag)

                case .share:
                    output.result.onNext(BaseEntity(status: 200, description: ""))
                }
            }).disposed(by: disposeBag)

        return output
    }
}
