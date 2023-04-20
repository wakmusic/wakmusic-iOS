import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    name: "CommonFeature",
    product: .staticFramework,
    packages: [
        .RealmSwift
    ],
    dependencies: [
        .Project.Features.BaseFeature,
        .SPM.RealmSwift
    ],
    resources: ["Resources/**"]
)
