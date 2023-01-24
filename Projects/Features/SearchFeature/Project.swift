import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    name: "SearchFeature",
    product: .staticFramework,
    dependencies: [
        .Project.Features.BaseFeature,
    ]
    , resources: ["Resources/**"]
)
