import DependencyPlugin
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.module(
    name: ModulePaths.Module.Localization.rawValue,
    targets: [
        .interface(module: .module(.Localization)),
        .implements(module: .module(.Localization), dependencies: [
            .module(target: .Localization, type: .interface)
        ])
    ]
)
