import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    name: "HomeFeature",
    product: .staticFramework,
    packages: [
        .RealmSwift
    ],
    dependencies: [
        .Project.Features.PlayerFeature,
        .SPM.RealmSwift
    ]
    , resources: ["Resources/**"]
)
