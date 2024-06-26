import RxSwift

public protocol UnSubscribePlaylistUseCase {
    func execute(key: String) -> Completable
}
