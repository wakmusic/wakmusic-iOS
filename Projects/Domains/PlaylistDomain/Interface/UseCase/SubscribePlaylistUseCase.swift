import RxSwift

public protocol SubscribePlaylistUseCase: Sendable {
    func execute(key: String, isSubscribing: Bool) -> Completable
}
