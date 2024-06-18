import Foundation
import MyInfoFeatureInterface
import NeedleFoundation
import NoticeDomainInterface
import UIKit

public protocol NoticeDetailDependency: Dependency {}

public final class NoticeDetailComponent: Component<NoticeDetailDependency>, NoticeDetailFactory {
    public func makeView(model: FetchNoticeEntity) -> UIViewController {
        return NoticeDetailViewController.viewController(
            viewModel: .init(
                model: model
            )
        )
    }
}
