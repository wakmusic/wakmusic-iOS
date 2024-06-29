import RxSwift

public protocol FetchFruitDrawStatusUseCase {
    func execute() -> Single<FruitDrawStatusEntity>
}
