import RxSwift

public protocol FetchCreditProfileImageURLUseCase {
    func execute(name: String) -> Single<String>
}
