import Foundation
import LogManager
import ReactorKit
import Utility

final class MyInfoReactor: Reactor {
    enum Action {}

    enum Mutation {}

    struct State {}

    var initialState: State
    private var disposeBag = DisposeBag()

    init() {
        self.initialState = .init()
    }
}
