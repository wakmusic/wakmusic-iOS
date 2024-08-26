import BaseFeatureInterface
import FruitDrawFeatureInterface
import MyInfoFeatureInterface
import NeedleFoundation
import NoticeDomainInterface
import SignInFeatureInterface
import TeamFeatureInterface
import UIKit
import UserDomainInterface

public protocol MyInfoDependency: Dependency {
    var signInFactory: any SignInFactory { get }
    var textPopupFactory: any TextPopupFactory { get }
    var multiPurposePopupFactory: any MultiPurposePopupFactory { get }
    var faqFactory: any FaqFactory { get }
    var noticeFactory: any NoticeFactory { get }
    var questionFactory: any QuestionFactory { get }
    var teamInfoFactory: any TeamInfoFactory { get }
    var settingFactory: any SettingFactory { get }
    var profilePopupFactory: any ProfilePopupFactory { get }
    var fruitDrawFactory: any FruitDrawFactory { get }
    var fruitStorageFactory: any FruitStorageFactory { get }
    var fetchNoticeIDListUseCase: any FetchNoticeIDListUseCase { get }
    var setUserNameUseCase: any SetUserNameUseCase { get }
    var fetchUserInfoUseCase: any FetchUserInfoUseCase { get }
}

public final class MyInfoComponent: Component<MyInfoDependency>, MyInfoFactory {
    public func makeView() -> UIViewController {
        return MyInfoViewController.viewController(
            reactor: MyInfoReactor(
                fetchNoticeIDListUseCase: dependency.fetchNoticeIDListUseCase,
                setUserNameUseCase: dependency.setUserNameUseCase,
                fetchUserInfoUseCase: dependency.fetchUserInfoUseCase
            ),
            profilePopupFactory: dependency.profilePopupFactory,
            textPopupFactory: dependency.textPopupFactory,
            multiPurposePopupFactory: dependency.multiPurposePopupFactory,
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
