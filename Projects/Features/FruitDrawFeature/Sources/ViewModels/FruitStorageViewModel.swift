import AuthDomainInterface
import BaseFeature
import Foundation
import LogManager
import RxRelay
import RxSwift
import UserDomainInterface
import Utility

public final class FruitStorageViewModel: ViewModelType {
    private let fetchFruitListUseCase: FetchFruitListUseCase
    private let logoutUseCase: LogoutUseCase
    private let disposeBag = DisposeBag()

    deinit {
        LogManager.printDebug("❌:: \(Self.self) deinit")
    }

    public init(
        fetchFruitListUseCase: any FetchFruitListUseCase,
        logoutUseCase: any LogoutUseCase
    ) {
        self.fetchFruitListUseCase = fetchFruitListUseCase
        self.logoutUseCase = logoutUseCase
    }

    public struct Input {
    }

    public struct Output {
    }

    public func transform(from input: Input) -> Output {
        let output = Output()
        return output
    }
}
