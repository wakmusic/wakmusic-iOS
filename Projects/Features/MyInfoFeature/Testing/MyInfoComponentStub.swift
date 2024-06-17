import BaseFeatureInterface
@testable import SignInFeatureTesting
@testable import BaseFeatureTesting
@testable import MyInfoFeature
import MyInfoFeatureInterface
import SignInFeatureInterface
import UIKit

public final class MyInfoComponentStub: MyInfoFactory {
    public func makeView() -> UIViewController {
        return MyInfoViewController.viewController(
            reactor: MyInfoReactor(),
            textPopUpFactory: TextPopUpComponentStub(),
            signInFactory: SignInComponentStub(),
            faqFactory: FaqComponentStub(),
            noticeFactory: NoticeComponentStub(),
            questionFactory: QuestionComponentStub(),
            teamInfoFactory: TeamInfoComponentStub(),
            settingFactory: SettingComponentStub()
        )
    }
}
