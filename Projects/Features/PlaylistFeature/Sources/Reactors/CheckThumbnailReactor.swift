import Foundation
import ReactorKit

final class CheckThumbnailReactor: Reactor {
    enum Action {
        case viewDidLoad
    }

    enum Mutation {
        case updateLoadingState(Bool)
    }

    struct State {
        var imageData: Data
        var guideLines: [String]
        var isLoading: Bool
    }

    var initialState: State

    init(imageData: Data) {
        initialState = State(imageData: imageData, guideLines: [], isLoading: true)
    }
}

extension CheckThumbnailReactor {}
