import BaseFeatureInterface
import MyInfoFeatureInterface
import NeedleFoundation
import SignInFeatureInterface
import UIKit

public protocol MyInfoDependency: Dependency {
    var signInFactory: any SignInFactory { get }
    var textPopUpFactory: any TextPopUpFactory { get }
    var faqComponent: FaqComponent { get }
    var noticeComponent: NoticeComponent { get }
    var questionComponent: QuestionComponent { get }
    var teamInfoComponent: TeamInfoComponent { get }
    var settingComponent: SettingComponent { get }
}

public final class MyInfoComponent: Component<MyInfoDependency>, MyInfoFactory {
    public func makeView() -> UIViewController {
        return MyInfoViewController.viewController(
            reactor: MyInfoReactor(),
            textPopUpFactory: dependency.textPopUpFactory,
            signInFactory: dependency.signInFactory,
            faqComponent: dependency.faqComponent,
            noticeComponent: dependency.noticeComponent,
            questionComponent: dependency.questionComponent,
            teamInfoComponent: dependency.teamInfoComponent,
            settingComponent: dependency.settingComponent
        )
    }
}
