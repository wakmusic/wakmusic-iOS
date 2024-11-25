import RxSwift

public protocol DrawFruitUseCase: Sendable {
    func execute() -> Single<FruitEntity>
}
