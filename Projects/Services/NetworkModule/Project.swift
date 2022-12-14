import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    name: "NetworkModule",
    product: .staticFramework,
    dependencies: [
        .Project.Module.UtilityModule,
        .Project.Service.APIModule,
        .SPM.Moya,
        .SPM.RxSwift,
        .SPM.RxCocoa,
    ]
)
