import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    name: "DesignSystem",
    product: .framework,
    dependencies: [
        .Project.Module.Utility
    ],
    resources: ["Resources/**"]
)
