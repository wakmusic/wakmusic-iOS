import AuthDomainInterface
import BaseFeature
import BaseFeatureInterface
import Foundation
import MyInfoFeatureInterface
import NeedleFoundation
import UserDomainInterface

public protocol RequestDependency: Dependency {
    var withdrawUserInfoUseCase: any WithdrawUserInfoUseCase { get }
    var logoutUseCase: any LogoutUseCase { get }
    var faqFactory: any FaqFactory { get }
    var questionFactory: any QuestionFactory { get }
    var noticeFactory: any NoticeFactory { get }
    var serviceInfoComponent: ServiceInfoComponent { get }
    var textPopUpFactory: any TextPopUpFactory { get }
}

public final class RequestComponent: Component<RequestDependency> {
    public func makeView() -> RequestViewController {
        return RequestViewController.viewController(
            viewModel: .init(
                withDrawUserInfoUseCase: dependency.withdrawUserInfoUseCase,
                logoutUseCase: dependency.logoutUseCase
            ),
            faqFactory: dependency.faqFactory,
            questionFactory: dependency.questionFactory,
            noticeFactory: dependency.noticeFactory,
            serviceInfoComponent: dependency.serviceInfoComponent,
            textPopUpFactory: dependency.textPopUpFactory
        )
    }
}
