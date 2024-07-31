import LikeDomainInterface
import RxSwift

public final class CheckIsLikedSongUseCaseImpl: CheckIsLikedSongUseCase {
    private let likeRepository: any LikeRepository

    public init(
        likeRepository: LikeRepository
    ) {
        self.likeRepository = likeRepository
    }

    public func execute(id: String) -> Single<Bool> {
        likeRepository.checkIsLikedSong(id: id)
    }
}
