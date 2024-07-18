import BaseFeature
import Foundation
import LogManager
import RxRelay
import RxSwift
import TeamDomainInterface

public final class TeamInfoContentViewModel: ViewModelType {
    private let entities: [TeamListEntity]
    private let disposeBag = DisposeBag()

    deinit {
        LogManager.printDebug("❌:: \(Self.self) deinit")
    }

    public init(
        entities: [TeamListEntity]
    ) {
        self.entities = entities
    }

    public struct Input {}

    public struct Output {
        let dataSource: BehaviorRelay<[TeamListEntity]> = .init(value: [])
    }

    public func transform(from input: Input) -> Output {
        let output = Output()
        return output
    }
}

private extension TeamInfoContentViewModel {
    func makeDummy() -> [TeamListEntity] {
        return []
    }
}
