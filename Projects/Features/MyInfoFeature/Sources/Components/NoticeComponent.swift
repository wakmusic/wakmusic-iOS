import Foundation
import MyInfoFeatureInterface
import NeedleFoundation
import NoticeDomainInterface
import UIKit

public protocol NoticeDependency: Dependency {
    var fetchNoticeUseCase: any FetchNoticeUseCase { get }
    var noticeDetailFactory: any NoticeDetailFactory { get }
}

public final class NoticeComponent: Component<NoticeDependency>, NoticeFactory {
    public func makeView() -> UIViewController {
        return NoticeViewController.viewController(
            viewModel: .init(
                fetchNoticeUseCase: dependency.fetchNoticeUseCase
            ),
            noticeDetailFactory: dependency.noticeDetailFactory
        )
    }
}
