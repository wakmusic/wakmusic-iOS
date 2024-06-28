import RxSwift

public protocol DrawFruitUseCase {
    func execute() -> Single<FruitEntity>
}
