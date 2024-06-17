import Foundation
import MyInfoFeatureInterface
import NoticeDomainInterface
@testable import NoticeDomainTesting
@testable import BaseFeatureTesting
import Foundation
@testable import MyInfoFeature
import UIKit


public final class NoticeComponentStub: NoticeFactory {
    public func makeView() -> UIViewController {
        return NoticeViewController.viewController(
            viewModel: .init(
                fetchNoticeUseCase: FetchNoticeUseCaseStub()
            ),
            noticeDetailFactory: NoticeDetailComponentStub()
        )
    }
}
