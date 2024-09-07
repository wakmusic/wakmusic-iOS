import BaseFeature
import Foundation
import LogManager
import RxRelay
import RxSwift
import TeamDomainInterface

public final class TeamInfoViewModel: ViewModelType {
    private let fetchTeamListUseCase: FetchTeamListUseCase
    private let disposeBag = DisposeBag()

    deinit {
        LogManager.printDebug("❌:: \(Self.self) deinit")
    }

    public init(
        fetchTeamListUseCase: any FetchTeamListUseCase
    ) {
        self.fetchTeamListUseCase = fetchTeamListUseCase
    }

    public struct Input {
        let fetchTeamList: PublishSubject<Void> = PublishSubject()
    }

    public struct Output {
        let dataSource: BehaviorRelay<[TeamListEntity]> = .init(value: [])
        let teams: BehaviorRelay<[String]> = .init(value: [])
    }

    public func transform(from input: Input) -> Output {
        let output = Output()

        input.fetchTeamList
            .flatMap { [weak self] _ -> Observable<[TeamListEntity]> in
                guard let self = self else { return .never() }
                return self.fetchTeamListUseCase.execute()
                    .asObservable()
                    .catchAndReturn([])
            }
            .do(onNext: { source in
                let teams: [String] = source.map { $0.team }.uniqueElements
                output.teams.accept(teams)
            })
            .bind(to: output.dataSource)
            .disposed(by: disposeBag)

        return output
    }
}
