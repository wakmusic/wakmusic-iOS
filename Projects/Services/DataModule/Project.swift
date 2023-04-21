import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    name: "DataModule",
    product: .staticFramework,
    packages: [
        .RealmSwift
    ],
    dependencies: [
        .Project.Service.Domain,
        .Project.Service.DatabaseModule,
        .Project.Service.NetworkModule,
        .SPM.RealmSwift
    ]
)
