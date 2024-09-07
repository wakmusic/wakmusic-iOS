import AuthDomainInterface
import BaseDomainInterface
import BaseFeature
import Foundation
import ImageDomainInterface
import RxRelay
import RxSwift
import UserDomainInterface
import Utility

public final class ProfilePopupViewModel: ViewModelType {
    private let fetchProfileListUseCase: FetchProfileListUseCase
    private let setProfileUseCase: SetProfileUseCase
    private let disposeBag = DisposeBag()

    public init(
        fetchProfileListUseCase: any FetchProfileListUseCase,
        setProfileUseCase: any SetProfileUseCase
    ) {
        self.fetchProfileListUseCase = fetchProfileListUseCase
        self.setProfileUseCase = setProfileUseCase
    }

    public struct Input {
        let fetchProfileList: PublishSubject<Void> = PublishSubject()
        let requestSetProfile: PublishSubject<Void> = PublishSubject()
        let itemSelected: PublishRelay<IndexPath> = PublishRelay()
    }

    public struct Output {
        let dataSource: BehaviorRelay<[ProfileListEntity]> = BehaviorRelay(value: [])
        let setProfileResult: PublishSubject<BaseEntity> = PublishSubject()
        let showToast: PublishSubject<String> = PublishSubject()
        let completedProfile: PublishSubject<Void> = PublishSubject()
    }

    public func transform(from input: Input) -> Output {
        let output = Output()

        input.fetchProfileList
            .flatMap { [fetchProfileListUseCase] _ in
                fetchProfileListUseCase.execute()
                    .asObservable()
                    .catchAndReturn([])
            }
            .bind(to: output.dataSource)
            .disposed(by: disposeBag)

        input.itemSelected
            .withLatestFrom(output.dataSource) { ($0, $1) }
            .map { indexPath, dataSource -> [ProfileListEntity] in
                var newModel = dataSource
                if let i = newModel.firstIndex(where: { $0.isSelected }) {
                    newModel[i].isSelected = false
                    newModel[indexPath.row].isSelected = true

                } else {
                    newModel[indexPath.row].isSelected = true
                    return newModel
                }
                return newModel
            }
            .bind(to: output.dataSource)
            .disposed(by: disposeBag)

        input.requestSetProfile
            .withLatestFrom(output.dataSource)
            .map { model in
                let id: String = model.filter { $0.isSelected }.first?.name ?? ""
                return id
            }
            .filter { !$0.isEmpty }
            .flatMap { [setProfileUseCase] profileName -> Observable<Void> in
                return setProfileUseCase.execute(image: profileName)
                    .andThen(Observable.just(()))
                    .catch { error in
                        output.showToast.onNext(error.asWMError.errorDescription ?? error.localizedDescription)
                        return Observable.empty()
                    }
            }
            .subscribe(onNext: { _ in
                output.showToast.onNext("프로필이 변경되었습니다.")
                output.completedProfile.onNext(())
            })
            .disposed(by: disposeBag)

        return output
    }
}
