//
//  ProfilePopViewModel.swift
//  CommonFeature
//
//  Created by KTH on 2023/02/18.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import BaseFeature
import DataMappingModule
import DomainModule
import Foundation
import RxCocoa
import RxSwift
import Utility

public final class ProfilePopViewModel {
    let input = Input()
    let output = Output()
    var disposeBag = DisposeBag()

    var fetchProfileListUseCase: FetchProfileListUseCase
    var setProfileUseCase: SetProfileUseCase

    public struct Input {
        var setProfileRequest: PublishSubject<String> = PublishSubject()
        var itemSelected: PublishRelay<IndexPath> = PublishRelay()
    }

    public struct Output {
        var setProfileResult: PublishSubject<BaseEntity> = PublishSubject()
        var dataSource: BehaviorRelay<[ProfileListEntity]> = BehaviorRelay(value: [])
        var collectionViewHeight: PublishRelay<CGFloat> = PublishRelay()
    }

    public init(
        fetchProfileListUseCase: any FetchProfileListUseCase,
        setProfileUseCase: any SetProfileUseCase
    ) {
        self.fetchProfileListUseCase = fetchProfileListUseCase
        self.setProfileUseCase = setProfileUseCase

        fetchProfileListUseCase.execute()
            .asObservable()
            .catchAndReturn([])
            .map { model -> [ProfileListEntity] in
                let currentProfile = Utility.PreferenceManager.userInfo?.profile ?? "unknown"

                var newModel = model
                newModel.indices
                    .forEach { newModel[$0].isSelected = (currentProfile == newModel[$0].type) }
                return newModel
            }
            .bind(to: output.dataSource)
            .disposed(by: disposeBag)

        output.dataSource
            .map { [weak self] model -> CGFloat in
                guard let self = self, !model.isEmpty else { return 0 }
                return self.getCollectionViewHeight(model: model)
            }
            .bind(to: output.collectionViewHeight)
            .disposed(by: disposeBag)

        input.itemSelected
            .withLatestFrom(output.dataSource) { ($0, $1) }
            .map { (indexPath: IndexPath, dataSource: [ProfileListEntity]) -> [ProfileListEntity] in
                var newModel = dataSource
                guard let index = newModel.firstIndex(where: { $0.isSelected }) else {
                    return dataSource
                }
                newModel[index].isSelected = false // 이전 선택 false
                newModel[indexPath.row].isSelected = true // 현재 선택 true
                return newModel
            }
            .bind(to: output.dataSource)
            .disposed(by: disposeBag)

        input.setProfileRequest
            .flatMap { [weak self] id -> Observable<BaseEntity> in
                guard let self = self else { return Observable.empty() }
                return self.setProfileUseCase.execute(image: id)
                    .catch { error in

                        let wmError = error.asWMError

                        if wmError == .tokenExpired {
                            return Single<BaseEntity>.create { single in
                                single(.success(BaseEntity(
                                    status: 401,
                                    description: error.asWMError.errorDescription ?? ""
                                )))
                                return Disposables.create {}
                            }
                        }

                        else {
                            return Single<BaseEntity>.create { single in
                                single(.success(BaseEntity(
                                    status: 0,
                                    description: error.asWMError.errorDescription ?? ""
                                )))
                                return Disposables.create {}
                            }
                        }

                    }.asObservable()
            }
            .withLatestFrom(input.setProfileRequest) { ($0, $1) }
            .do(onNext: { [weak self] model, profile in

                guard let self else { return }

                if model.status == 401 {
                    return
                }

                guard model.status == 200 else { return }
                Utility.PreferenceManager.userInfo = Utility.PreferenceManager.userInfo?.update(profile: profile)
            })
            .map { $0.0 }
            .bind(to: output.setProfileResult)
            .disposed(by: disposeBag)
    }

    private func getCollectionViewHeight(model: [ProfileListEntity]) -> CGFloat {
        let spacing: CGFloat = 10.0
        let itemHeight: CGFloat = (APP_WIDTH() - 70) / 4

        let mok: Int = model.count / 4
        let remain: Int = model.count % 4

        if model.count == 1 {
            return itemHeight

        } else {
            if remain == 0 {
                return (CGFloat(mok) * itemHeight) + (CGFloat(mok - 1) * spacing)
            } else {
                return (CGFloat(mok) * itemHeight) + (CGFloat(remain) * itemHeight) + (CGFloat(mok - 1) * spacing) +
                    (CGFloat(remain) * spacing)
            }
        }
    }
}
