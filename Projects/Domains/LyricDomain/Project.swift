import DependencyPlugin
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.module(
    name: ModulePaths.Domain.LyricDomain.rawValue,
    targets: [
        .interface(
            module: .domain(.LyricDomain),
            dependencies: [
                .domain(target: .BaseDomain, type: .interface)
            ]
        ),
        .implements(
            module: .domain(.LyricDomain),
            dependencies: [
                .domain(target: .BaseDomain),
                .domain(target: .LyricDomain, type: .interface)
            ]
        )
    ]
)
