import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    name: "RootFeature",
    product: .staticFramework,
    dependencies: [
        .Project.Features.BaseFeature,
        .Project.Features.MainTabFeature,
        .Project.Features.PlayerFeature,
        .Project.Features.SignInFeature
    ]
    , resources: ["Resources/**"]
)
