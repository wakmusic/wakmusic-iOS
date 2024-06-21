import Foundation
import RxSwift
import ReactorKit

final class MyPlaylistDetailReactor: Reactor {
    
    enum Action {
        
    }
    
    enum Mutation {
        
    }
    
    struct State {
        var isEditing: Bool
    }
    
    var initialState: State
    
    init() {
        self.initialState =  State(
            isEditing: false
        )
    }
    
    
}
