import Foundation
import NoticeDomainInterface
import RxSwift

public struct FetchNoticeAllUseCaseStub: FetchNoticeAllUseCase {
    public func execute() -> Single<[FetchNoticeEntity]> {
        let title1 = "공지사항 두줄인 경우 공지사항 두줄인 경우 공지사항 두줄인 경우 공지사항 두줄인 경우"
        let title2 = "왁타버스 뮤직 2.0 업데이트"
        let content2 =
            "공지사항 내용이 나옵니다.\n위아래 여백에 맞춰 답변 길이가 유동적으로 바뀝니다.\n\n자주 묻는 질문 답변이 나옵니다.\n위아래 여백에 맞춰 답변 길이가 유동적으로 바뀝니다."
        let stubs = [
            FetchNoticeEntity(
                id: 99992,
                category: "카테고리1",
                title: title1,
                content: "",
                thumbnail: .init(url: "", link: ""),
                origins: [],
                createdAt: 1
            ),
            FetchNoticeEntity(
                id: 99993,
                category: "카테고리2",
                title: title2,
                content: "",
                thumbnail: .init(url: "", link: ""),
                origins: [],
                createdAt: 2
            )
        ]
        return .just(stubs)
    }

    public init() {}
}
