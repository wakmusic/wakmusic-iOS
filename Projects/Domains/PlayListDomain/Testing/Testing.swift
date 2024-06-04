import PlayListDomainInterface
import RxSwift

final class FetchPlayListUseCaseSpy: FetchRecommendPlayListUseCase {
    var fetchData = [
        RecommendPlayListEntity(
            key: "best",
            title: "베스트",
            image: "https://cdn.wakmusic.xyz/playlist/best_1.png",
            private: false,
            count: 0
        ),
        RecommendPlayListEntity(
            key: "carol",
            title: "캐롤",
            image: "https://cdn.wakmusic.xyz/playlist/carol_1.png",
            private: false,
            count: 0
        ),
        RecommendPlayListEntity(
            key: "competition",
            title: "경쟁",
            image: "https://cdn.wakmusic.xyz/playlist/competition_1.png",
            private: false,
            count: 0
        ),
        RecommendPlayListEntity(
            key: "best",
            title: "베스트",
            image: "https://cdn.wakmusic.xyz/playlist/best_1.png",
            private: false,
            count: 0
        ),
        RecommendPlayListEntity(
            key: "carol",
            title: "캐롤",
            image: "https://cdn.wakmusic.xyz/playlist/carol_1.png",
            private: false,
            count: 0
        ),
        RecommendPlayListEntity(
            key: "competition",
            title: "경쟁",
            image: "https://cdn.wakmusic.xyz/playlist/competition_1.png",
            private: false,
            count: 0
        ),
        RecommendPlayListEntity(
            key: "best",
            title: "베스트",
            image: "https://cdn.wakmusic.xyz/playlist/best_1.png",
            private: false,
            count: 0
        ),
        RecommendPlayListEntity(
            key: "carol",
            title: "캐롤",
            image: "https://cdn.wakmusic.xyz/playlist/carol_1.png",
            private: false,
            count: 0
        ),
        RecommendPlayListEntity(
            key: "competition",
            title: "경쟁",
            image: "https://cdn.wakmusic.xyz/playlist/competition_1.png",
            private: false,
            count: 0
        ),
        RecommendPlayListEntity(
            key: "best",
            title: "베스트",
            image: "https://cdn.wakmusic.xyz/playlist/best_1.png",
            private: false,
            count: 0
        ),
        RecommendPlayListEntity(
            key: "carol",
            title: "캐롤",
            image: "https://cdn.wakmusic.xyz/playlist/carol_1.png",
            private: false,
            count: 0
        ),
        RecommendPlayListEntity(
            key: "competition",
            title: "경쟁",
            image: "https://cdn.wakmusic.xyz/playlist/competition_1.png",
            private: false,
            count: 0
        ),
        RecommendPlayListEntity(
            key: "best",
            title: "베스트",
            image: "https://cdn.wakmusic.xyz/playlist/best_1.png",
            private: false,
            count: 0
        ),
        RecommendPlayListEntity(
            key: "carol",
            title: "캐롤",
            image: "https://cdn.wakmusic.xyz/playlist/carol_1.png",
            private: false,
            count: 0
        ),
        RecommendPlayListEntity(
            key: "competition",
            title: "경쟁",
            image: "https://cdn.wakmusic.xyz/playlist/competition_1.png",
            private: false,
            count: 0
        ),
        RecommendPlayListEntity(
            key: "best",
            title: "베스트",
            image: "https://cdn.wakmusic.xyz/playlist/best_1.png",
            private: false,
            count: 0
        ),
        RecommendPlayListEntity(
            key: "carol",
            title: "캐롤",
            image: "https://cdn.wakmusic.xyz/playlist/carol_1.png",
            private: false,
            count: 0
        ),
        RecommendPlayListEntity(
            key: "competition",
            title: "경쟁",
            image: "https://cdn.wakmusic.xyz/playlist/competition_1.png",
            private: false,
            count: 0
        )
    ]

    func execute() -> Single<[RecommendPlayListEntity]> {
        return Single.create { [weak self] single in

            guard let self else {
                return Disposables.create()
            }

            single(.success(self.fetchData))
            return Disposables.create()
        }
    }
}
