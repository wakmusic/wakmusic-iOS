import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    name: "ChartFeature",
    product: .staticFramework,
    dependencies: [
        .Project.Features.PlayerFeature
    ]
    , resources: ["Resources/**"]
)
