import Foundation
import RxSwift
import UserDomainInterface

public struct FetchPlaylistUseCaseStub: FetchPlaylistUseCase {
    let items: [PlaylistEntity] = [
        .init(
            key: "123",
            title: "우중충한 장마철 여름에 듣기 좋은 일본 시티팝 플레이리스트",
            image: "",
            songCount: 0,
            userId: "",
            private: true
        ),
        .init(
            key: "1234",
            title: "비내리는 도시, 세련된 무드 감각적인 팝송☔️ 분위기 있는 노래 모음",
            image: "",
            songCount: 1,
            userId: "",
            private: true
        ),
        .init(
            key: "1424",
            title: "[𝐏𝐥𝐚𝐲𝐥𝐢𝐬𝐭] 여름 밤, 퇴근길에 꽂는 플레이리스트🚃",
            image: "",
            songCount: 200,
            userId: "",
            private: false
        ),
        .init(
            key: "1324",
            title: "𝐏𝐥𝐚𝐲𝐥𝐢𝐬𝐭 벌써 여름이야? 내 방을 청량한 캘리포니아 해변으로 신나는 여름 팝송 𝐒𝐮𝐦𝐦𝐞𝐫 𝐢𝐬 𝐜𝐨𝐦𝐢𝐧𝐠 🌴",
            image: "",
            songCount: 1000,
            userId: "", private: true
        )
    ]

    public init() {}

    public func execute() -> Single<[PlaylistEntity]> {
        return .just(items).delay(.seconds(1), scheduler: MainScheduler.instance)
    }
}
