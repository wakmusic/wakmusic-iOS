import RxSwift

public protocol SubscribePlaylistUseCase {
    func execute(key: String, isSubscribing: Bool) -> Completable
}
