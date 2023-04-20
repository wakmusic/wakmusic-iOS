import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    name: "RootFeature",
    product: .staticFramework,
    packages: [
        .RealmSwift
    ],
    dependencies: [
        .Project.Features.BaseFeature,
        .Project.Features.MainTabFeature,
        .SPM.RealmSwift
    ]
    , resources: ["Resources/**"]
)
