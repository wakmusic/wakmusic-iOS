import RxSwift

public protocol FetchFruitListUseCase {
    func execute() -> Single<[FruitEntity]>
}
