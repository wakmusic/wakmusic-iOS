import RxSwift

public protocol CheckIsExistAccessTokenUseCase: Sendable {
    func execute() -> Single<Bool>
}
