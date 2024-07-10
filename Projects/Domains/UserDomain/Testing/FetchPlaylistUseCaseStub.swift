import Foundation
import RxSwift
import UserDomainInterface
import Utility

public struct FetchPlayListUseCaseStub: FetchPlayListUseCase {
    let items: [PlayListEntity] = [
        .init(
            key: "123",
            title: "우중충한 장마철 여름에 듣기 좋은 일본 시티팝 플레이리스트",
            image: "",
            songlist: [],
            image_version: 0
        ),
        .init(
            key: "1234",
            title: "비내리는 도시, 세련된 무드 감각적인 팝송☔️ 분위기 있는 노래 모음",
            image: "",
            songlist: [],
            image_version: 0
        ),
        .init(
            key: "1234",
            title: "[𝐏𝐥𝐚𝐲𝐥𝐢𝐬𝐭] 여름 밤, 퇴근길에 꽂는 플레이리스트🚃",
            image: "",
            songlist: [],
            image_version: 0
        ),
        .init(
            key: "1234",
            title: "𝐏𝐥𝐚𝐲𝐥𝐢𝐬𝐭 벌써 여름이야? 내 방을 청량한 캘리포니아 해변으로 신나는 여름 팝송 𝐒𝐮𝐦𝐦𝐞𝐫 𝐢𝐬 𝐜𝐨𝐦𝐢𝐧𝐠 🌴",
            image: "",
            songlist: [],
            image_version: 0
        )
    ]

    public init() {}

    public func execute() -> Single<[PlayListEntity]> {
        let isLoggedIn = PreferenceManager.userInfo != nil
        let items = isLoggedIn ? items : []
        return .just(items).delay(.seconds(1), scheduler: MainScheduler.instance)
    }
}
