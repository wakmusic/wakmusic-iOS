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
    }

    public func transform(from input: Input) -> Output {
        let output = Output()

        input.fetchTeamList
            .flatMap { [weak self] _ -> Single<[TeamListEntity]> in
                guard let self = self else { return .never() }
                return self.fetchTeamListUseCase.execute()
                    .catchAndReturn(self.makeDummy())
            }
            .bind(to: output.dataSource)
            .disposed(by: disposeBag)

        return output
    }
}

private extension TeamInfoViewModel {
    func makeDummy() -> [TeamListEntity] {
        return [
            .init(team: "기획 · 디자인", name: "샴퓨", position: "Product Designer", profile: "", isLead: true),
            .init(team: "기획 · 디자인", name: "스타티스", position: "작가", profile: "", isLead: false),
            .init(team: "기획 · 디자인", name: "Wacter", position: "영상", profile: "", isLead: false),
            .init(team: "iOS 개발", name: "iOS Hamp", position: "개발자", profile: "", isLead: true),
            .init(team: "iOS 개발", name: "구구", position: "개발자", profile: "", isLead: false),
            .init(team: "iOS 개발", name: "baegteun", position: "개발자", profile: "", isLead: false),
            .init(team: "iOS 개발", name: "케이", position: "개발자", profile: "", isLead: false),
            .init(team: "iOS 개발", name: "김대희", position: "개발자", profile: "", isLead: false),
            .init(team: "AOS 개발", name: "Hees", position: "개발자", profile: "", isLead: true),
            .init(team: "AOS 개발", name: "깊은꿈속", position: "개발자", profile: "", isLead: false),
            .init(team: "AOS 개발", name: "민감자", position: "개발자", profile: "", isLead: false),
            .init(team: "AOS 개발", name: "다블람", position: "개발자", profile: "", isLead: false),
            .init(team: "Back-End 개발", name: "코코아", position: "개발자", profile: "", isLead: true),
            .init(team: "Web 개발", name: "니엔", position: "개발자", profile: "", isLead: true)
        ]
    }
}
