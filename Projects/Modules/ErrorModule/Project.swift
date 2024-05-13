import DependencyPlugin
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.module(
    name: ModulePaths.Module.ErrorModule.rawValue,
    targets: [
        .implements(module: .module(.ErrorModule), product: .framework)
    ]
)
