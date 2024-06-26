import BaseFeatureInterface
import MyInfoFeatureInterface
import NeedleFoundation
import SignInFeatureInterface
import UIKit

public protocol MyInfoDependency: Dependency {
    var signInFactory: any SignInFactory { get }
    var textPopUpFactory: any TextPopUpFactory { get }
    var faqFactory: any FaqFactory { get }
    var noticeFactory: any NoticeFactory { get }
    var questionFactory: any QuestionFactory { get }
    var teamInfoFactory: any TeamInfoFactory { get }
    var settingFactory: any SettingFactory { get }
    var profilePopComponent: ProfilePopComponent { get }
}

public final class MyInfoComponent: Component<MyInfoDependency>, MyInfoFactory {
    public func makeView() -> UIViewController {
        return MyInfoViewController.viewController(
            reactor: MyInfoReactor(),
            profilePopUpComponent: dependency.profilePopComponent,
            textPopUpFactory: dependency.textPopUpFactory,
            signInFactory: dependency.signInFactory,
            faqFactory: dependency.faqFactory,
            noticeFactory: dependency.noticeFactory,
            questionFactory: dependency.questionFactory,
            teamInfoFactory: dependency.teamInfoFactory,
            settingFactory: dependency.settingFactory
        )
    }
}
