import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    name: "SearchFeature",
    product: .staticFramework,
    dependencies: [
        .Project.Features.PlayerFeature
    ]
    , resources: ["Resources/**"]
)
