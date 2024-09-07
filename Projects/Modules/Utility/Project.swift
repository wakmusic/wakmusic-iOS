import DependencyPlugin
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.module(
    name: ModulePaths.Module.Utility.rawValue,
    targets: [
        .implements(module: .module(.Utility), product: .framework, dependencies: [
            .module(target: .LogManager),
            .module(target: .ThirdPartyLib)
        ])
    ]
)
