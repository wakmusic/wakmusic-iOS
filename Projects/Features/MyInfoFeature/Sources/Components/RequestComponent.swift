import AuthDomainInterface
import BaseFeature
import BaseFeatureInterface
import Foundation
import NeedleFoundation
import UserDomainInterface
import MyInfoFeatureInterface

public protocol RequestDependency: Dependency {
    var withdrawUserInfoUseCase: any WithdrawUserInfoUseCase { get }
    var logoutUseCase: any LogoutUseCase { get }
    var faqFactory: any FaqFactory { get }
    var questionComponent: QuestionComponent { get }
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
            questionComponent: dependency.questionComponent,
            noticeFactory: dependency.noticeFactory,
            serviceInfoComponent: dependency.serviceInfoComponent,
            textPopUpFactory: dependency.textPopUpFactory
        )
    }
}
