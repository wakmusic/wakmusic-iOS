import BaseFeatureInterface
import FruitDrawFeatureInterface
import MyInfoFeatureInterface
import NeedleFoundation
import SignInFeatureInterface
import UIKit

public protocol MyInfoDependency: Dependency {
    var signInFactory: any SignInFactory { get }
    var textPopUpFactory: any TextPopUpFactory { get }
    var multiPurposePopUpFactory: any MultiPurposePopUpFactory { get }
    var faqFactory: any FaqFactory { get }
    var noticeFactory: any NoticeFactory { get }
    var questionFactory: any QuestionFactory { get }
    var teamInfoFactory: any TeamInfoFactory { get }
    var settingFactory: any SettingFactory { get }
    var profilePopComponent: ProfilePopComponent { get }
    var fruitDrawFactory: any FruitDrawFactory { get }
}

public final class MyInfoComponent: Component<MyInfoDependency>, MyInfoFactory {
    public func makeView() -> UIViewController {
        return MyInfoViewController.viewController(
            reactor: MyInfoReactor(),
            profilePopUpComponent: dependency.profilePopComponent,
            textPopUpFactory: dependency.textPopUpFactory,
            multiPurposePopUpFactory: dependency.multiPurposePopUpFactory,
            signInFactory: dependency.signInFactory,
            faqFactory: dependency.faqFactory,
            noticeFactory: dependency.noticeFactory,
            questionFactory: dependency.questionFactory,
            teamInfoFactory: dependency.teamInfoFactory,
            settingFactory: dependency.settingFactory,
            fruitDrawFactory: dependency.fruitDrawFactory
        )
    }
}
