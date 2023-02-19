import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    name: "HomeFeature",
    product: .staticFramework,
    dependencies: [
        .Project.Features.PlayerFeature
    ]
    , resources: ["Resources/**"]
)
