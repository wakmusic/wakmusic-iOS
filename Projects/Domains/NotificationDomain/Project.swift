import DependencyPlugin
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.module(
    name: ModulePaths.Domain.NotificationDomain.rawValue,
    targets: [
        .interface(
            module: .domain(.NotificationDomain),
            dependencies: [
                .domain(target: .BaseDomain, type: .interface)
            ]
        ),
        .implements(
            module: .domain(.NotificationDomain),
            dependencies: [
                .domain(target: .BaseDomain),
                .domain(target: .NotificationDomain, type: .interface)
            ]
        )
    ]
)
