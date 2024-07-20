import DependencyPlugin
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.module(
    name: ModulePaths.Module.Localization.rawValue,
    targets: [
        .implements(
            module: .module(.Localization),
            product: .staticFramework,
            spec: .init(
                resources: ["Resources/**"],
                dependencies: []
            )
        ),
    ]
)
