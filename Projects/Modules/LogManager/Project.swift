import DependencyPlugin
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.module(
    name: ModulePaths.Module.LogManager.rawValue,
    targets: [
        .implements(module: .module(.LogManager), product: .framework, dependencies: [
            .module(target: .ThirdPartyLib)
        ])
    ]
)
