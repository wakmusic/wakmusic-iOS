import DependencyPlugin
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.module(
    name: ModulePaths.Module.KeychainModule.rawValue,
    targets: [
        .implements(module: .module(.KeychainModule), product: .framework)
    ]
)
