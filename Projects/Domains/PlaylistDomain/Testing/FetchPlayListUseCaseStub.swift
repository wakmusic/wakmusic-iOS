import PlaylistDomainInterface
import RxSwift

final class FetchPlayListUseCaseStub: FetchRecommendPlaylistUseCase {
    var fetchData = [
        RecommendPlaylistEntity(
            key: "best",
            title: "베스트",
            image: "https://cdn.wakmusic.xyz/playlist/best_1.png",
            private: false,
            count: 0
        ),
        RecommendPlaylistEntity(
            key: "carol",
            title: "캐롤",
            image: "https://cdn.wakmusic.xyz/playlist/carol_1.png",
            private: false,
            count: 0
        ),
        RecommendPlaylistEntity(
            key: "competition",
            title: "경쟁",
            image: "https://cdn.wakmusic.xyz/playlist/competition_1.png",
            private: false,
            count: 0
        ),
        RecommendPlaylistEntity(
            key: "best",
            title: "베스트",
            image: "https://cdn.wakmusic.xyz/playlist/best_1.png",
            private: false,
            count: 0
        ),
        RecommendPlaylistEntity(
            key: "carol",
            title: "캐롤",
            image: "https://cdn.wakmusic.xyz/playlist/carol_1.png",
            private: false,
            count: 0
        ),
        RecommendPlaylistEntity(
            key: "competition",
            title: "경쟁",
            image: "https://cdn.wakmusic.xyz/playlist/competition_1.png",
            private: false,
            count: 0
        ),
        RecommendPlaylistEntity(
            key: "best",
            title: "베스트",
            image: "https://cdn.wakmusic.xyz/playlist/best_1.png",
            private: false,
            count: 0
        ),
        RecommendPlaylistEntity(
            key: "carol",
            title: "캐롤",
            image: "https://cdn.wakmusic.xyz/playlist/carol_1.png",
            private: false,
            count: 0
        ),
        RecommendPlaylistEntity(
            key: "competition",
            title: "경쟁",
            image: "https://cdn.wakmusic.xyz/playlist/competition_1.png",
            private: false,
            count: 0
        ),
        RecommendPlaylistEntity(
            key: "best",
            title: "베스트",
            image: "https://cdn.wakmusic.xyz/playlist/best_1.png",
            private: false,
            count: 0
        ),
        RecommendPlaylistEntity(
            key: "carol",
            title: "캐롤",
            image: "https://cdn.wakmusic.xyz/playlist/carol_1.png",
            private: false,
            count: 0
        ),
        RecommendPlaylistEntity(
            key: "competition",
            title: "경쟁",
            image: "https://cdn.wakmusic.xyz/playlist/competition_1.png",
            private: false,
            count: 0
        ),
        RecommendPlaylistEntity(
            key: "best",
            title: "베스트",
            image: "https://cdn.wakmusic.xyz/playlist/best_1.png",
            private: false,
            count: 0
        ),
        RecommendPlaylistEntity(
            key: "carol",
            title: "캐롤",
            image: "https://cdn.wakmusic.xyz/playlist/carol_1.png",
            private: false,
            count: 0
        ),
        RecommendPlaylistEntity(
            key: "competition",
            title: "경쟁",
            image: "https://cdn.wakmusic.xyz/playlist/competition_1.png",
            private: false,
            count: 0
        ),
        RecommendPlaylistEntity(
            key: "best",
            title: "베스트",
            image: "https://cdn.wakmusic.xyz/playlist/best_1.png",
            private: false,
            count: 0
        ),
        RecommendPlaylistEntity(
            key: "carol",
            title: "캐롤",
            image: "https://cdn.wakmusic.xyz/playlist/carol_1.png",
            private: false,
            count: 0
        ),
        RecommendPlaylistEntity(
            key: "competition",
            title: "경쟁",
            image: "https://cdn.wakmusic.xyz/playlist/competition_1.png",
            private: false,
            count: 0
        )
    ]

    func execute() -> Single<[RecommendPlaylistEntity]> {
        return Single.create { [fetchData] single in

            single(.success(fetchData))
            return Disposables.create()
        }
    }
}
