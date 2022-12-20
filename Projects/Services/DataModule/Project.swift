import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    name: "DataModule",
    product: .staticFramework,
    dependencies: [
        .Project.Service.DomainModule,
        .Project.Service.DatabaseModule,
        .Project.Service.NetworkModule,
        .SPM.RxSwift
    ]
)
