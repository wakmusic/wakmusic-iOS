import ProjectDescription
import ProjectDescriptionHelpers
import UtilityPlugin

let project = Project.makeModule(
    name: "ThirdPartyLib",
    product: .framework,
    dependencies: [
        .SPM.RxSwift,
        .SPM.RxMoya,
        .SPM.Moya
    ]
)
