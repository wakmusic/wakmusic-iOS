import BaseFeature
import Foundation
import LogManager
import RxRelay
import RxSwift
import TeamDomainInterface
import TeamFeatureInterface

public final class TeamInfoContentViewModel: ViewModelType {
    private let entities: [TeamListEntity]
    private let disposeBag = DisposeBag()

    deinit {
        LogManager.printDebug("❌:: \(Self.self) deinit")
    }

    public init(entities: [TeamListEntity]) {
        self.entities = entities
    }

    public struct Input {
        let combineTeamList: PublishSubject<Void> = .init()
    }

    public struct Output {
        let dataSource: BehaviorRelay<[TeamInfoSectionModel]> = .init(value: [])
    }

    public func transform(from input: Input) -> Output {
        let output = Output()
        let entities = self.entities
        let teams = entities.map { $0.team }.uniqueElements

        input.combineTeamList
            .map { [weak self] _ in
                guard let self = self else { return [] }
                return teams.map { team -> TeamInfoSectionModel in
                    return TeamInfoSectionModel(
                        title: team,
                        model: TeamInfoModel(
                            members: entities.filter { $0.team == team },
                            isOpen: true
                        )
                    )
                }
            }
            .bind(to: output.dataSource)
            .disposed(by: disposeBag)

        return output
    }
}

private extension TeamInfoContentViewModel {
    func makeDummy() -> TeamListEntity {
        return TeamListEntity(team: "", name: "", position: "", profile: "", isLead: true)
    }
}
