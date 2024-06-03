import BaseDomainInterface
import Foundation
import PlayListDomainInterface
import RxSwift

public struct UpdatePlaylistUseCaseImpl: UpdatePlaylistUseCase {
    private let playListRepository: any PlayListRepository

    public init(
        playListRepository: PlayListRepository
    ) {
        self.playListRepository = playListRepository
    }

    public func execute(key: String, songs: [String]) -> Completable {
        return playListRepository.updatePlayList(key: key, songs: songs)
    }
}
