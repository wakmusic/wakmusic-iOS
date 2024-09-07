import DependencyPlugin
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.module(
    name: ModulePaths.Domain.ImageDomain.rawValue,
    targets: [
        .interface(
            module: .domain(.ImageDomain),
            dependencies: [
                .domain(target: .BaseDomain, type: .interface)
            ]
        ),
        .implements(
            module: .domain(.ImageDomain),
            dependencies: [
                .domain(target: .BaseDomain),
                .domain(target: .ImageDomain, type: .interface)
            ]
        )
    ]
)
