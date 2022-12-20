import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    name: "APIModule",
    product: .staticFramework,
    dependencies: [
        .Project.Module.KeychainModule,
        .Project.Module.ErrorModule,
        .Project.Service.DataMappingModule,
        .SPM.RxMoya,
        .SPM.RxSwift
    ]
)
