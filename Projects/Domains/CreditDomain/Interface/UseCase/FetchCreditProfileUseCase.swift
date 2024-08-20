import RxSwift

public protocol FetchCreditProfileUseCase {
    func execute(name: String) -> Single<CreditProfileEntity>
}
