import ProjectDescription
import ProjectDescriptionHelpers
import UtilityPlugin

let project = Project.makeModule(
    name: "ThirdPartyLib",
    product: .framework,
    packages: [
        .RealmSwift
    ],
    dependencies: [
        .SPM.NaverLogin,
        .SPM.RxSwift,
        .SPM.RxMoya,
        .SPM.Moya,
        .SPM.RealmSwift,
        .SPM.Amplify,
        .SPM.AWSPluginsCore,
        .SPM.AWSS3StoragePlugin
    ]
)
