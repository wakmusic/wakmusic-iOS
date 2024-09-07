import Foundation
import LogManager
import ReactorKit
import RxSwift
import SongsDomainInterface

public final class AfterSearchReactor: Reactor {
    var disposeBag: DisposeBag = DisposeBag()

    private let service: any SearchCommonService

    public enum Action {}

    public enum Mutation {
        case updateText(String)
    }

    public struct State {
        var text: String
    }

    public var initialState: State

    init(service: some SearchCommonService = DefaultSearchCommonService.shared, text: String) {
        self.initialState = State(
            text: text
        )
        self.service = service
    }

    deinit {
        LogManager.printDebug("\(Self.self)")
    }

    public func mutate(action: Action) -> Observable<Mutation> {}

    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state

        switch mutation {
        case let .updateText(text):
            newState.text = text
        }

        return newState
    }
}

private extension AfterSearchReactor {
    #warning("유즈케이스 주입")
}
