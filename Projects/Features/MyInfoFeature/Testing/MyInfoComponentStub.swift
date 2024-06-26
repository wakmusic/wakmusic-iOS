import BaseFeatureInterface
@testable import BaseFeatureTesting
@testable import MyInfoFeature
import MyInfoFeatureInterface
import SignInFeatureInterface
@testable import SignInFeatureTesting
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
            settingFactory: SettingComponentStub(),
            fruitDrawFactory: FruitDrawComponentStub()
        )
    }
}
