import Foundation
import RxSwift
import UserDomainInterface

public struct FetchFavoriteSongsUseCaseStub: FetchFavoriteSongsUseCase {
    let items: [FavoriteSongEntity] = [
        .init(
            songID: "fgSXAKsq-Vo",
            title: "리와인드 (RE:WIND)",
            artist: "이세계아이돌",
            like: 10
        ),
        .init(
            songID: "6GQV6lhwgNs",
            title: "팬서비스",
            artist: "세구",
            like: 100
        )
    ]

    public init() {}

    public func execute() -> Single<[FavoriteSongEntity]> {
        return .just(items).delay(.seconds(1), scheduler: MainScheduler.instance)
    }
}
