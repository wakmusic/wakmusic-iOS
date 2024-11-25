import RxSwift

public protocol FetchFruitDrawStatusUseCase: Sendable {
    func execute() -> Single<FruitDrawStatusEntity>
}
