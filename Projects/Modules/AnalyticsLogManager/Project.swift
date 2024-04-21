import DependencyPlugin
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.module(
    name: ModulePaths.Module.AnalyticsLogManager.rawValue,
    targets: [
        .implements(module: .module(.AnalyticsLogManager))
    ]
)
