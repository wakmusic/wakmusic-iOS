import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    name: "StorageFeature",
    product: .staticFramework,
    dependencies: [
        .Project.Features.BaseFeature
    ]
    , resources: ["Resources/**"]
)
