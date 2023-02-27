import ProjectDescription
import ProjectDescriptionHelpers
import UtilityPlugin

let project = Project.makeModule(
    name: "ThirdPartyLib",
    product: .framework,
    packages: [
        .GoogleSignIn
    ],
    dependencies: [
        .SPM.GoogleSignIn,
        .SPM.NaverLogin,
        .SPM.Firebase,
        .SPM.RxSwift,
        .SPM.RxMoya,
        .SPM.Moya
    ]
)
