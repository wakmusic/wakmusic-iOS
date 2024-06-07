import BaseDomainInterface
import Foundation
import PlayListDomainInterface
import RxSwift

public struct UpdateTitleAndPrivateUseCaseImpl: UpdateTitleAndPrivateUseCase {
    private let playListRepository: any PlayListRepository

    public init(
        playListRepository: PlayListRepository
    ) {
        self.playListRepository = playListRepository
    }

    public func execute(key: String, title: String?, isPrivate: Bool?) -> Completable {
        playListRepository.updateTitleAndPrivate(key: key, title: title, isPrivate: isPrivate)
    }
}
