import RxSwift

public protocol CheckIsExistAccessTokenUseCase {
    func execute() -> Single<Bool>
}
