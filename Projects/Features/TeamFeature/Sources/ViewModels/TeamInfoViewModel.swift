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
        let dataSource: BehaviorRelay<([TeamListEntity], [TeamListEntity])> = .init(value: ([], []))
    }

    public func transform(from input: Input) -> Output {
        let output = Output()

        input.fetchTeamList
            .flatMap { [weak self] _ -> Observable<([TeamListEntity], [TeamListEntity])> in
                guard let self = self else { return .never() }
                return Observable.zip(
                    self.fetchTeamListUseCase.execute()
                        .asObservable()
                        .catchAndReturn(self.makeDummy1()),
                    self.fetchTeamListUseCase.execute()
                        .asObservable()
                        .catchAndReturn(self.makeDummy2())
                )
            }
            .bind(to: output.dataSource)
            .disposed(by: disposeBag)

        return output
    }
}

private extension TeamInfoViewModel {
    func makeDummy1() -> [TeamListEntity] {
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

    func makeDummy2() -> [TeamListEntity] {
        return [
            .init(team: "영상", name: "미니박스", position: "영상 · 개발자", profile: "", isLead: true),
            .init(team: "영상", name: "라스", position: "영상 · 시트 · TMI", profile: "", isLead: false),
            .init(team: "영상", name: "하루", position: "영상", profile: "", isLead: false),
            .init(team: "시트", name: "수학", position: "시트 · 썸네일 · TMI", profile: "", isLead: false),
            .init(team: "녹화", name: "똘저놈", position: "개발자", profile: "", isLead: false),
            .init(team: "녹화", name: "내이름은이든", position: "개발자", profile: "", isLead: false),
            .init(team: "썸네일", name: "Mudori", position: "썸네일", profile: "", isLead: false),
            .init(team: "TMI", name: "225", position: "TMI", profile: "", isLead: false),
            .init(team: "TMI", name: "하늘참", position: "TMI", profile: "", isLead: false),
            .init(team: "TMI", name: "찬란한빛", position: "TMI", profile: "", isLead: false),
            .init(team: "TMI", name: "듀엘이에요", position: "TMI", profile: "", isLead: false),
            .init(team: "TMI", name: "루엘", position: "TMI", profile: "", isLead: false),
            .init(team: "TMI", name: "소프트피치", position: "TMI", profile: "", isLead: false),
            .init(team: "연출", name: "찌랭이", position: "연출 기획", profile: "", isLead: false),
            .init(team: "연출", name: "설가람", position: "연출 기획", profile: "", isLead: true),
            .init(team: "연출", name: "공대문과생", position: "연출 기획", profile: "", isLead: false),
            .init(team: "연출", name: "에이요", position: "연출 편집", profile: "", isLead: false),
            .init(team: "연출", name: "LCM", position: "연출 편집", profile: "", isLead: false),
            .init(team: "연출", name: "브푸", position: "연출 편집", profile: "", isLead: false),
            .init(team: "연출", name: "DO_S", position: "연출 편집", profile: "", isLead: false),
            .init(team: "연출", name: "티콘", position: "연출 SFX", profile: "", isLead: false)
        ]
    }
}
