import Foundation
import DomainModule
import NeedleFoundation

public protocol PlayerDependency: Dependency {
    var fetchLyricsUseCase: any FetchLyricsUseCase { get }
}

public final class PlayerComponent: Component<PlayerDependency> {
    public func makeView() -> PlayerViewController {
        return PlayerViewController(viewModel: .init(fetchLyricsUseCase: dependency.fetchLyricsUseCase))
    }
}
