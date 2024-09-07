import DependencyPlugin
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.module(
    name: ModulePaths.Domain.TeamDomain.rawValue,
    targets: [
        .interface(
            module: .domain(.TeamDomain),
            dependencies: [
                .domain(target: .BaseDomain, type: .interface)
            ]
        ),
        .implements(
            module: .domain(.TeamDomain),
            dependencies: [
                .domain(target: .BaseDomain),
                .domain(target: .TeamDomain, type: .interface)
            ]
        )
    ]
)
