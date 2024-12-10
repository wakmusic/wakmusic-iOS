import RxSwift

public protocol FetchCreditProfileUseCase: Sendable {
    func execute(name: String) -> Single<CreditProfileEntity>
}
