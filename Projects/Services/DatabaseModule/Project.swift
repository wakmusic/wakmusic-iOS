import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    name: "DatabaseModule",
    product: .staticFramework,
    packages: [
        .RealmSwift
    ],
    dependencies: [
        .Project.Module.Utility,
        .SPM.RealmSwift
    ]
)
