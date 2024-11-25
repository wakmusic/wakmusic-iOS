import RxSwift

public protocol FetchFruitListUseCase: Sendable {
    func execute() -> Single<[FruitEntity]>
}
