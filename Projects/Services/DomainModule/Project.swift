import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    name: "DomainModule",
    product: .staticFramework,
    packages: [
        .RealmSwift
    ],
    dependencies: [
        .Project.Module.ThirdPartyLib,
        .Project.Service.DataMappingModule,
        .SPM.RealmSwift
    ]
)
