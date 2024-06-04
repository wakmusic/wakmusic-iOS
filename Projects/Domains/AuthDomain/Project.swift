import DependencyPlugin
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.module(
    name: ModulePaths.Domain.AuthDomain.rawValue,
    targets: [
        .interface(
            module: .domain(.AuthDomain),
            dependencies: [
                .domain(target: .BaseDomain, type: .interface)
            ]
        ),
        .implements(
            module: .domain(.AuthDomain),
            dependencies: [
                .domain(target: .BaseDomain),
                .domain(target: .AuthDomain, type: .interface)
            ]
        ),
        .testing(
            module: .domain(.AuthDomain),
            dependencies: [.domain(target: .AuthDomain, type: .interface)]
        ),
        .tests(
            module: .domain(.AuthDomain),
            dependencies: [.domain(target: .AuthDomain)]
        )
    ]
)
