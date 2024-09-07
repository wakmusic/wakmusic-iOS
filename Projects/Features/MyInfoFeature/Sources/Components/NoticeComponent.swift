import Foundation
import MyInfoFeatureInterface
import NeedleFoundation
import NoticeDomainInterface
import UIKit

public protocol NoticeDependency: Dependency {
    var fetchNoticeAllUseCase: any FetchNoticeAllUseCase { get }
    var noticeDetailFactory: any NoticeDetailFactory { get }
}

public final class NoticeComponent: Component<NoticeDependency>, NoticeFactory {
    public func makeView() -> UIViewController {
        return NoticeViewController.viewController(
            viewModel: .init(
                fetchNoticeAllUseCase: dependency.fetchNoticeAllUseCase
            ),
            noticeDetailFactory: dependency.noticeDetailFactory
        )
    }
}
