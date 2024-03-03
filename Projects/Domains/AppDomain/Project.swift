import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.module(
    name: ModulePaths.Domain.AppDomain.rawValue,
    targets: [
        .implements(
            module: .domain(.AppDomain),
            product: .staticFramework,
            dependencies: [
                TargetDependency.domain(target: .BaseDomain),
                TargetDependency.domain(target: .AppDomain, type: .interface)
            ]
        ),
        .interface(module: .domain(.AppDomain)),
        .tests(
            module: .domain(.AppDomain),
            dependencies: [.domain(target: .AppDomain)]
        )
    ]
)
