import Foundation
@testable import MyInfoFeature
import MyInfoFeatureInterface
import NoticeDomainInterface
import UIKit

public final class NoticeDetailComponentStub: NoticeDetailFactory, @unchecked Sendable {
    public func makeView(model: FetchNoticeEntity) -> UIViewController {
        return NoticeDetailViewController.viewController(
            viewModel: .init(
                model: model
            )
        )
    }
}
