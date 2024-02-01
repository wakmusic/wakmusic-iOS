import ProjectDescription
import ProjectDescriptionHelpers
import UtilityPlugin

let project = Project.makeModule(
    name: "ThirdPartyLib",
    product: .framework,
    dependencies: [
        .Carthage.Realm,
        .Carthage.RealmSwift,
        .SPM.NaverLogin,
        .SPM.RxSwift,
        .SPM.RxMoya,
        .SPM.Moya,
        .SPM.FirebaseAnalytics,
        .SPM.FirebaseCrashlytics
    ]
)
