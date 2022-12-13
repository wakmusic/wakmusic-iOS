import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    name: "UtilityModule",
    product: .staticFramework,
    dependencies: [
        .Project.Module.ErrorModule
    ]
)
