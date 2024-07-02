import ReactorKit


final class ThumbnailPopupReactor: Reactor {
    
    enum Action {
        case viewDidLoad
    }
    
    enum Mutation {
        case updateDataSource([ThumbnailOptionModel])
    }
    
    struct State {
        var dataSource: [ThumbnailOptionModel]
    }
    
    var initialState: State
    
    #warning("가격 UseCase")
    init() {
        initialState = State(
            dataSource: []
        )
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        
        switch action {
            
            case .viewDidLoad:
                return updateDataSource()
            
        }
        
        
        
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        
        var newState = state
        
        switch mutation {
            
        case let .updateDataSource(dataSource):
            newState.dataSource = dataSource
        }
        
        
        
        return newState
    }
    
}

extension ThumbnailPopupReactor {
    func updateDataSource() -> Observable<Mutation> {
        
        return .just(.updateDataSource([ ThumbnailOptionModel(title: "이미지 선택", cost: 0), ThumbnailOptionModel(title: "앨범에서 고르기", cost: 3) ]))

    }
}
