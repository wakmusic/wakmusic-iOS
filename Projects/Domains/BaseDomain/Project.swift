import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.module(
    name: ModulePaths.Domain.BaseDomain.rawValue,
    targets: [
        .implements(
            module: .domain(.BaseDomain),
            product: .staticFramework
        ),
        .interface(module: .domain(.BaseDomain)),
        .tests(
            module: .domain(.BaseDomain),
            dependencies: [.domain(target: .BaseDomain, type: .interface)]
        )
    ]
)
