import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.module(
    name: ModulePaths.Domain.AppDomain.rawValue,
    targets: [
        .interface(module: .domain(.AppDomain)),
        .implements(
            module: .domain(.AppDomain),
            dependencies: [
                TargetDependency.domain(target: .BaseDomain),
                TargetDependency.domain(target: .AppDomain, type: .interface)
            ]
        ),
        .tests(
            module: .domain(.AppDomain),
            dependencies: [.domain(target: .AppDomain)]
        )
    ]
)
