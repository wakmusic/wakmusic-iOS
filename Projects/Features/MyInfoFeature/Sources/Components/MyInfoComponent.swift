import BaseFeatureInterface
import FruitDrawFeatureInterface
import MyInfoFeatureInterface
import NeedleFoundation
import NoticeDomainInterface
import SignInFeatureInterface
import TeamFeatureInterface
import UIKit

public protocol MyInfoDependency: Dependency {
    var signInFactory: any SignInFactory { get }
    var textPopUpFactory: any TextPopUpFactory { get }
    var multiPurposePopUpFactory: any MultiPurposePopupFactory { get }
    var faqFactory: any FaqFactory { get }
    var noticeFactory: any NoticeFactory { get }
    var questionFactory: any QuestionFactory { get }
    var teamInfoFactory: any TeamInfoFactory { get }
    var settingFactory: any SettingFactory { get }
    var profilePopComponent: ProfilePopComponent { get }
    var fruitDrawFactory: any FruitDrawFactory { get }
    var fruitStorageFactory: any FruitStorageFactory { get }
    var fetchNoticeIDListUseCase: any FetchNoticeIDListUseCase { get }
}

public final class MyInfoComponent: Component<MyInfoDependency>, MyInfoFactory {
    public func makeView() -> UIViewController {
        return MyInfoViewController.viewController(
            reactor: MyInfoReactor(
                fetchNoticeIDListUseCase: dependency.fetchNoticeIDListUseCase
            ),
            profilePopUpComponent: dependency.profilePopComponent,
            textPopUpFactory: dependency.textPopUpFactory,
            multiPurposePopUpFactory: dependency.multiPurposePopUpFactory,
            signInFactory: dependency.signInFactory,
            faqFactory: dependency.faqFactory,
            noticeFactory: dependency.noticeFactory,
            questionFactory: dependency.questionFactory,
            teamInfoFactory: dependency.teamInfoFactory,
            settingFactory: dependency.settingFactory,
            fruitDrawFactory: dependency.fruitDrawFactory,
            fruitStorageFactory: dependency.fruitStorageFactory
        )
    }
}
