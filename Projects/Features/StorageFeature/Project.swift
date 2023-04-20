import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    name: "StorageFeature",
    product: .staticFramework,
    packages: [
        .RealmSwift
    ],
    dependencies: [
        .Project.Features.SignInFeature,
        .SPM.RealmSwift
    ]
    , resources: ["Resources/**"]
)
