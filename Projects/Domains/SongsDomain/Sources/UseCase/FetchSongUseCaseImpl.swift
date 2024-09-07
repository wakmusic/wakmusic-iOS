import AuthDomainInterface
import LikeDomainInterface
import RxSwift
import SongsDomainInterface

public struct FetchSongUseCaseImpl: FetchSongUseCase {
    private let songsRepository: any SongsRepository
    private let likeRepository: any LikeRepository
    private let authRepository: any AuthRepository

    public init(
        songsRepository: SongsRepository,
        likeRepository: any LikeRepository,
        authRepository: any AuthRepository
    ) {
        self.songsRepository = songsRepository
        self.likeRepository = likeRepository
        self.authRepository = authRepository
    }

    public func execute(id: String) -> Single<SongDetailEntity> {
        authRepository.checkIsExistAccessToken()
            .flatMap { isLoggedIn in
                let fetchSong = songsRepository.fetchSong(id: id)
                guard isLoggedIn else {
                    return fetchSong.map {
                        $0.toDetailEntity(isLiked: false)
                    }
                }

                let fetchIsLiked = likeRepository.checkIsLikedSong(id: id)
                return Single.zip(fetchSong, fetchIsLiked)
                    .map { song, isLiked in
                        song.toDetailEntity(isLiked: isLiked)
                    }
            }
    }
}

private extension SongEntity {
    func toDetailEntity(isLiked: Bool) -> SongDetailEntity {
        SongDetailEntity(
            id: self.id,
            title: self.title,
            artist: self.artist,
            views: self.views,
            date: self.date,
            likes: self.likes,
            isLiked: isLiked,
            karaokeNumber: .init(
                tj: self.karaokeNumber.TJ,
                ky: self.karaokeNumber.KY
            )
        )
    }
}
