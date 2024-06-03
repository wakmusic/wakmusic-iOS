import Foundation
import NeedleFoundation
import PlayListDomainInterface
import UIKit

public protocol WakmusicRecommendDependency: Dependency {
    var fetchRecommendPlayListUseCase: any  FetchRecommendPlayListUseCase { get }
}

public final class WakmusicRecommendComponent: Component<WakmusicRecommendDependency> {
    public func makeView() -> UIViewController {
        return WakmusicRecommendViewController(
            reactor: WakmusicRecommendReactor(
                fetchRecommendPlayListUseCase: dependency.fetchRecommendPlayListUseCase
            )
        )
    }
}
