import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    name: "PlayerFeature",
    product: .staticFramework,
    packages: [
        .RealmSwift
    ],
    dependencies: [
        .Project.Features.CommonFeature,
        .SPM.RealmSwift
    ]
)
