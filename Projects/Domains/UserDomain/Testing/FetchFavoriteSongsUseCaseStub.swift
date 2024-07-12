import Foundation
import RxSwift
import UserDomainInterface

public struct FetchFavoriteSongsUseCaseStub: FetchFavoriteSongsUseCase {
    let items: [FavoriteSongEntity] = [
        .init(
            like: 1,
            song: .init(
                id: "123",
                title: "리와인드 (RE:WIND)",
                artist: "이세계아이돌",
                remix: "",
                reaction: "",
                views: 10,
                last: 1,
                date: ""
            ),
            isSelected: false
        ),
        .init(
            like: 1,
            song: .init(
                id: "123",
                title: "리와인드 (RE:WIND)",
                artist: "이세계아이돌",
                remix: "",
                reaction: "",
                views: 10,
                last: 1,
                date: ""
            ),
            isSelected: false
        ),
        .init(
            like: 1,
            song: .init(
                id: "123",
                title: "리와인드 (RE:WIND)",
                artist: "이세계아이돌",
                remix: "",
                reaction: "",
                views: 10,
                last: 1,
                date: ""
            ),
            isSelected: false
        ),
        .init(
            like: 1,
            song: .init(
                id: "123",
                title: "리와인드 (RE:WIND)",
                artist: "이세계아이돌",
                remix: "",
                reaction: "",
                views: 10,
                last: 1,
                date: ""
            ),
            isSelected: false
        )
    ]

    public init() {}

    public func execute() -> Single<[FavoriteSongEntity]> {
        return .just(items).delay(.seconds(1), scheduler: MainScheduler.instance)
    }
}
