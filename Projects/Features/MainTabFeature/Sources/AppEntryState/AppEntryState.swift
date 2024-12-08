import Foundation
import RxRelay

public protocol AppEntryStateHandleable: Sendable {
    var moveSceneObservable: BehaviorRelay<[String: Any]> { get }
    func moveScene(params: [String: Any])
}

public final class AppEntryState: AppEntryStateHandleable, @unchecked Sendable {
    private let moveSceneRelay: BehaviorRelay<[String: Any]> = .init(value: [:])

    public var moveSceneObservable: BehaviorRelay<[String: Any]> {
        return moveSceneRelay
    }

    public func moveScene(params: [String: Any]) {
        moveSceneRelay.accept(params)
    }

    public init() {}
}
