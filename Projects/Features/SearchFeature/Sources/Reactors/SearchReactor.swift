import BaseFeature
import Foundation
import LogManager
import ReactorKit
import RxRelay
import RxSwift
import Utility

public final class SearchReactor: Reactor {
    public enum Action {}

    public enum Mutation {}

    public struct State {}

    public var initialState: State

    init() {
        self.initialState = .init()
    }

    deinit {
        LogManager.printDebug("❌ \(Self.self) deinit")
    }

    public func reduce(state: State, mutation: Mutation) -> State {}

    public func mutate(action: Action) -> Observable<Mutation> {}
}
