import BaseDomainInterface
import Foundation
import PlaylistDomainInterface
import RxSwift

public struct UpdateTitleAndPrivateUseCaseImpl: UpdateTitleAndPrivateUseCase {
    private let playListRepository: any PlaylistRepository

    public init(
        playListRepository: PlaylistRepository
    ) {
        self.playListRepository = playListRepository
    }

    public func execute(key: String, title: String?, isPrivate: Bool?) -> Completable {
        playListRepository.updateTitleAndPrivate(key: key, title: title, isPrivate: isPrivate)
    }
}
