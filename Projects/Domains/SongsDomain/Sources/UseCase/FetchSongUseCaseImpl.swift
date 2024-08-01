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
                let fetchIsLiked = likeRepository.checkIsLikedSong(id: id)
                return Single.zip(fetchSong, fetchIsLiked)
                    .map { song, isLiked in
                        SongDetailEntity(
                            id: song.id,
                            title: song.title,
                            artist: song.artist,
                            views: song.views,
                            date: song.date,
                            likes: song.likes,
                            isLiked: isLiked,
                            karaokeNumber: .init(
                                tj: song.karaokeNumber.TJ,
                                ky: song.karaokeNumber.KY
                            )
                        )
                    }
            }
    }
}
