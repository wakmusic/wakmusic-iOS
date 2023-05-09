import ProjectDescription
import ProjectDescriptionHelpers
import UtilityPlugin

let project = Project.makeModule(
    name: "ThirdPartyLib",
    product: .framework,
    dependencies: [
        .XCFramework.Realm,
        .XCFramework.RealmSwift,
        .SPM.NaverLogin,
        .SPM.RxSwift,
        .SPM.RxMoya,
        .SPM.Moya,
        .SPM.Amplify,
        .SPM.AWSPluginsCore,
        .SPM.AWSS3StoragePlugin
    ]
)
