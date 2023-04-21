import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    name: "NetworkModule",
    product: .staticFramework,
    packages: [
        .RealmSwift
    ],
    dependencies: [
        .Project.Module.Utility,
        .Project.Service.APIKit,
        .Project.Service.Domain,
        .SPM.RealmSwift
    ]
)
