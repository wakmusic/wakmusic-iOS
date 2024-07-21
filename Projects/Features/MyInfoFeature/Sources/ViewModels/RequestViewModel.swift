////
////  AfterLoginStorageViewModel.swift
////  StorageFeature
////
////  Created by yongbeomkwak on 2023/01/26.
////  Copyright © 2023 yongbeomkwak. All rights reserved.
////
//
//import AuthDomainInterface
//import BaseDomainInterface
//import BaseFeature
//import Foundation
//import NaverThirdPartyLogin
//import RxRelay
//import RxSwift
//import UserDomainInterface
//import Utility
//
//public final class RequestViewModel: ViewModelType {
//    var disposeBag = DisposeBag()
//    var withDrawUserInfoUseCase: WithdrawUserInfoUseCase
//    private let logoutUseCase: any LogoutUseCase
//    let naverLoginInstance = NaverThirdPartyLoginConnection.getSharedInstance()
//
//    public struct Input {
//        let pressWithdraw: PublishSubject<Void> = PublishSubject()
//    }
//
//    public struct Output {
//        let withDrawResult: PublishSubject<BaseEntity> = PublishSubject()
//    }
//
//    public init(
//        withDrawUserInfoUseCase: WithdrawUserInfoUseCase,
//        logoutUseCase: any LogoutUseCase
//    ) {
//        self.withDrawUserInfoUseCase = withDrawUserInfoUseCase
//        self.logoutUseCase = logoutUseCase
//        DEBUG_LOG("✅ \(Self.self) 생성")
//    }
//
//    public func transform(from input: Input) -> Output {
//        let output = Output()
//
//        input.pressWithdraw
//            .debug("pressWithdraw")
//            .flatMap { [weak self] _ -> Observable<BaseEntity> in
//                guard let self else { return Observable.empty() }
//                return withDrawUserInfoUseCase.execute()
//                    .andThen(
//                        .concat(
//                            handleThirdPartyWithDraw(),
//                            logout()
//                        )
//                    )
//                    .catch { error in
//                        Observable.create { observable in
//                            observable.onNext(BaseEntity(
//                                status: 0,
//                                description: error.asWMError.errorDescription ?? ""
//                            ))
//                            observable.onCompleted()
//                            return Disposables.create{}
//                        }
//                    }
//            }
//            .bind(to: output.withDrawResult)
//            .disposed(by: disposeBag)
//
//        return output
//    }
//}
//
//private extension RequestViewModel {
//    func handleThirdPartyWithDraw() -> Observable<BaseEntity> {
//        let platform = Utility.PreferenceManager.userInfo?.platform
//        if platform == "naver" {
//            naverLoginInstance?.requestDeleteToken()
//        }
//        return .empty()
//    }
//    
//    func logout() -> Observable<BaseEntity> {
//        logoutUseCase.execute()
//            .andThen(
//                Observable.create { observable in
//                    observable.onNext(BaseEntity(
//                        status: 200,
//                        description: "회원탈퇴가 완료되었습니다.\n이용해주셔서 감사합니다."
//                    ))
//                    observable.onCompleted()
//                    return Disposables.create{}
//                }
//            )
//            .catch { error in
//                Observable.create { observable in
//                    observable.onNext(BaseEntity(
//                        status: 0,
//                        description: error.asWMError.errorDescription ?? ""
//                    ))
//                    observable.onCompleted()
//                    return Disposables.create{}
//                }
//            }
//    }
//  
//}
