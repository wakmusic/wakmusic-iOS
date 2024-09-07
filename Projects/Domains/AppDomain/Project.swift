import DependencyPlugin
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.module(
    name: ModulePaths.Domain.AppDomain.rawValue,
    targets: [
        .interface(
            module: .domain(.AppDomain),
            dependencies: [
                .domain(target: .BaseDomain, type: .interface)
            ]
        ),
        .implements(
            module: .domain(.AppDomain),
            dependencies: [
                .domain(target: .BaseDomain),
                .domain(target: .AppDomain, type: .interface)
            ]
        ),
        .tests(
            module: .domain(.AppDomain),
            dependencies: [.domain(target: .AppDomain)]
        )
    ]
)
