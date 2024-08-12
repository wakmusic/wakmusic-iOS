import Foundation
import PlaylistDomainInterface
import ReactorKit
import RxSwift

final class PlaylistDetailContainerReactor: Reactor {
    enum Action {
        case requestOwnerID
        case clearOwnerID
    }

    enum Mutation {
        case updateOwnerID(String?)
        case updateLoadingState(Bool)
        case showToastMessagae(String)
        case updateDetectedNotFound
    }

    struct State {
        var isLoading: Bool
        var ownerID: String?
        @Pulse var toastMessgae: String?
        @Pulse var detectedNotFound: Void?
    }

    private let requestPlaylistOwnerIDUsecase: any RequestPlaylistOwnerIDUsecase
    let key: String
    var initialState: State

    init(key: String, requestPlaylistOwnerIDUsecase: any RequestPlaylistOwnerIDUsecase) {
        self.key = key
        initialState = State(isLoading: true)
        self.requestPlaylistOwnerIDUsecase = requestPlaylistOwnerIDUsecase
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .requestOwnerID:
            return updateOwnerID()
        case .clearOwnerID:
            return clearOwnerID()
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state

        switch mutation {
        case let .updateOwnerID(ownerID):
            newState.ownerID = ownerID
        case let .showToastMessagae(message):
            newState.toastMessgae = message
        case let .updateLoadingState(flag):
            newState.isLoading = flag
        case .updateDetectedNotFound:
            newState.detectedNotFound = ()
        }

        return newState
    }
}

extension PlaylistDetailContainerReactor {
    func updateOwnerID() -> Observable<Mutation> {
        return .concat([
            updateLoadingState(flag: true),
            updateOwnerIDMutation(),
            updateLoadingState(flag: false)
        ])
    }

    func updateOwnerIDMutation() -> Observable<Mutation> {
        return requestPlaylistOwnerIDUsecase
            .execute(key: key)
            .asObservable()
            .flatMap { entitiy -> Observable<Mutation> in
                return .just(Mutation.updateOwnerID(entitiy.ownerID))
            }
            .catch { error in
                let wmError = error.asWMError

                if wmError == .notFound {
                    return self.updateDetectedNotFound()
                }

                return .just(Mutation.showToastMessagae(wmError.localizedDescription))
            }
    }

    func updateLoadingState(flag: Bool) -> Observable<Mutation> {
        return .just(.updateLoadingState(flag))
    }

    func clearOwnerID() -> Observable<Mutation> {
        return .concat([
            Observable.just(Mutation.updateOwnerID(nil)),
            Observable.just(.updateLoadingState(false))
        ])
    }

    func updateDetectedNotFound() -> Observable<Mutation> {
        .just(.updateDetectedNotFound)
    }
}
