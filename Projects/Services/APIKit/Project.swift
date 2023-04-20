import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    name: "APIKit",
    product: .staticFramework,
    packages: [
        .RealmSwift
    ],
    dependencies: [
        .Project.Module.ThirdPartyLib,
        .Project.Module.KeychainModule,
        .Project.Module.ErrorModule,
        .Project.Service.DataMappingModule,
        .SPM.RealmSwift
    ]
)
