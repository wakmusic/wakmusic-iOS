import Foundation
import ReactorKit
import PlaylistDomainInterface
import RxSwift

final class PlaylistDetailContainerReactor: Reactor {
    
    enum Action {
        case requestOwnerId
    }
    
    enum Mutation {
        case updateOwnerId(String)
        case updateLoadingState(Bool)
        case showToastMessagae(String)
    }
     
    struct State {
        var isLoading: Bool
        var ownerID: String?
        @Pulse var toastMessgae: String?
    }
    
    private let requestPlaylistOwnerIdUsecase: any RequestPlaylistOwnerIdUsecase
    let key: String
    var initialState: State
    
    init(key: String, requestPlaylistOwnerIdUsecase: any RequestPlaylistOwnerIdUsecase) {
        self.key = key
        initialState = State(isLoading: true)
        self.requestPlaylistOwnerIdUsecase = requestPlaylistOwnerIdUsecase
    }
    
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .requestOwnerId:
            return updateOwnerId()
        }
    }
    
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
            
        case let .updateOwnerId(ownerID):
            newState.ownerID = ownerID
        case let .showToastMessagae(message):
            newState.toastMessgae = message
        case let .updateLoadingState(flag):
            newState.isLoading = flag
        }
        
        return newState
    }
    
}

extension PlaylistDetailContainerReactor{
    func updateOwnerId() -> Observable<Mutation> {

        return requestPlaylistOwnerIdUsecase
            .execute(key: key)
            .asObservable()
            .catchAndReturn(PlaylistOwnerIdEntity(ownerID: "__"))
            .flatMap({ entitiy -> Observable<Mutation> in
                return .just(Mutation.updateOwnerId(entitiy.ownerID))
            })
        
    }
    
    func updateLoadingState(flag: Bool) -> Observable<Mutation> {
        
        return .just(.updateLoadingState(flag))
    }
}
