import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    name: "PlayerFeature",
    product: .staticFramework,
    dependencies: [
        .Project.Features.BaseFeature,
    ]
    , resources: ["Resources/**"]

)
