import BaseFeature
import Foundation
import LogManager
import RxRelay
import RxSwift
import TeamDomainInterface
import TeamFeatureInterface

public final class TeamInfoContentViewModel: ViewModelType {
    private let type: TeamInfoType
    private let entities: [TeamListEntity]
    private let disposeBag = DisposeBag()

    deinit {
        LogManager.printDebug("❌:: \(Self.self) deinit")
    }

    public init(type: TeamInfoType, entities: [TeamListEntity]) {
        self.type = type
        self.entities = entities
    }

    public struct Input {
        let combineTeamList: PublishSubject<Void> = .init()
    }

    public struct Output {
        let dataSource: BehaviorRelay<[TeamInfoSectionModel]> = .init(value: [])
        let updateManager: BehaviorRelay<TeamListEntity?> = BehaviorRelay(value: nil)
        let type: BehaviorRelay<TeamInfoType> = .init(value: .develop)
    }

    public func transform(from input: Input) -> Output {
        let output = Output()
        let entities = self.entities
        let parts = entities.map { $0.part }.filter { $0 != "총괄" }.uniqueElements

        output.updateManager.accept(entities.filter { $0.isManager }.first)
        output.type.accept(type)

        input.combineTeamList
            .map { _ -> [TeamInfoSectionModel] in
                return parts.map { part -> TeamInfoSectionModel in
                    return TeamInfoSectionModel(
                        title: part,
                        model: TeamInfoModel(
                            members: entities.filter { $0.part == part },
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
