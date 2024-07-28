import AuthDomainInterface
import BaseDomainInterface
import BaseFeature
import Foundation
import ImageDomainInterface
import RxRelay
import RxSwift
import UserDomainInterface
import Utility

public final class ProfilePopViewModel {
    let input = Input()
    let output = Output()
    var disposeBag = DisposeBag()

    var fetchProfileListUseCase: FetchProfileListUseCase
    var setProfileUseCase: SetProfileUseCase
    private let logoutUseCase: any LogoutUseCase

    public struct Input {
        var setProfileRequest: PublishSubject<String> = PublishSubject()
        var itemSelected: PublishRelay<IndexPath> = PublishRelay()
    }

    public struct Output {
        var setProfileResult: PublishSubject<BaseEntity> = PublishSubject()
        var dataSource: BehaviorRelay<[ProfileListEntity]> = BehaviorRelay(value: [])
        var collectionViewHeight: PublishRelay<CGFloat> = PublishRelay()
        let onLogout: PublishRelay<Error> = PublishRelay()
    }

    public init(
        fetchProfileListUseCase: any FetchProfileListUseCase,
        setProfileUseCase: any SetProfileUseCase,
        logoutUseCas: any LogoutUseCase
    ) {
        self.fetchProfileListUseCase = fetchProfileListUseCase
        self.setProfileUseCase = setProfileUseCase
        self.logoutUseCase = logoutUseCas

        fetchProfileListUseCase.execute()
            .asObservable()
            .catchAndReturn([])
            .map { model -> [ProfileListEntity] in
                let currentProfile = Utility.PreferenceManager.userInfo?.profile ?? "unknown"

                var newModel = model
                newModel.indices
                    .forEach { newModel[$0].isSelected = (currentProfile == newModel[$0].name) }
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
                guard let self else { return Observable.empty() }
                return setProfile(imageId: id)
            }
            .withLatestFrom(input.setProfileRequest) { ($0, $1) }
            .do(onNext: updateUserInfoProfile)
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

private extension ProfilePopViewModel {
    func setProfile(imageId: String) -> Observable<BaseEntity> {
        return self.setProfileUseCase.execute(image: imageId)
            .andThen(
                Observable<BaseEntity>.create { observable in
                    observable.onNext(BaseEntity(
                        status: 200,
                        description: "success"
                    ))
                    observable.onCompleted()
                    return Disposables.create {}
                }
            )
            .catch(handleSetProfileError)
    }

    func handleSetProfileError(error: Error) -> Observable<BaseEntity> {
        let wmError = error.asWMError

        if wmError == .tokenExpired {
            output.onLogout.accept(error)
            return logoutUseCase.execute()
                .andThen(.never())
                .catch { error in
                    return Observable.just(BaseEntity(
                        status: 0,
                        description: error.asWMError.errorDescription ?? ""
                    ))
                }
        } else {
            return Observable.just(BaseEntity(
                status: 0,
                description: error.asWMError.errorDescription ?? ""
            ))
        }
    }

    func updateUserInfoProfile(model: BaseEntity, profileURL: String) {
        switch model.status {
        case 200:
            Utility.PreferenceManager.userInfo = Utility.PreferenceManager.userInfo?.update(profile: profileURL)
        default:
            break
        }
        return
    }
}
