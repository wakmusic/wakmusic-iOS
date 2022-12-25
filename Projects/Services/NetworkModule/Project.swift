import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    name: "NetworkModule",
    product: .staticFramework,
    dependencies: [
        .Project.Module.UtilityModule,
        .Project.Service.APIModule,
        .Project.Service.DomainModule,
        .SPM.RxMoya,
        .SPM.RxSwift
    ]
)
