import DependencyPlugin
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.module(
    name: ModulePaths.Module.ThirdPartyLib.rawValue,
    targets: [
        .implements(
            module: .module(.ThirdPartyLib),
            product: .framework,
            dependencies: [
                .XCFramework.Realm,
                .XCFramework.RealmSwift,
                .SPM.NaverLogin,
                .SPM.RxSwift,
                .SPM.RxMoya,
                .SPM.Moya,
                .SPM.FirebaseAnalytics,
                .SPM.FirebaseCrashlytics,
                .SPM.CryptoSwift,
                .SPM.FirebaseMessaging
                
            ]
        )
    ]
)
