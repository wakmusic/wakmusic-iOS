import Foundation
import ReactorKit
import PlaylistDomainInterface
import RxSwift

final class PlaylistDetailContainerReactor: Reactor {
    
    enum Action {
        case requestOwnerID
    }
    
    enum Mutation {
        case updateOwnerID(String)
        case updateLoadingState(Bool)
        case showToastMessagae(String)
    }
     
    struct State {
        var isLoading: Bool
        var ownerID: String?
        @Pulse var toastMessgae: String?
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
        }
        
        return newState
    }
    
}

extension PlaylistDetailContainerReactor{
    func updateOwnerID() -> Observable<Mutation> {

        return requestPlaylistOwnerIDUsecase
            .execute(key: key)
            .asObservable()
            .catchAndReturn(PlaylistOwnerIDEntity(ownerID: "__"))
            .flatMap({ entitiy -> Observable<Mutation> in
                return .just(Mutation.updateOwnerID(entitiy.ownerID))
            })
        
    }
    
    func updateLoadingState(flag: Bool) -> Observable<Mutation> {
        
        return .just(.updateLoadingState(flag))
    }
}
