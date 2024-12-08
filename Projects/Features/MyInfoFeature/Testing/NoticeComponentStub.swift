@testable import BaseFeatureTesting
import Foundation
@testable import MyInfoFeature
import MyInfoFeatureInterface
import NoticeDomainInterface
@testable import NoticeDomainTesting
import UIKit

public final class NoticeComponentStub: NoticeFactory, @unchecked Sendable {
    public func makeView() -> UIViewController {
        return NoticeViewController.viewController(
            viewModel: .init(
                fetchNoticeAllUseCase: FetchNoticeAllUseCaseStub()
            ),
            noticeDetailFactory: NoticeDetailComponentStub()
        )
    }
}
