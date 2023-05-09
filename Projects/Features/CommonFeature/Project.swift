import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    name: "CommonFeature",
    product: .staticFramework,
    dependencies: [
        .Project.Features.BaseFeature
    ],
    resources: ["Resources/**"]
)
