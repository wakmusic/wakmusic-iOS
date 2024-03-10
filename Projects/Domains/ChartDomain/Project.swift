import DependencyPlugin
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.module(
    name: ModulePaths.Domain.ChartDomain.rawValue,
    targets: [
        .interface(module: .domain(.ChartDomain)),
        .implements(
            module: .domain(.ChartDomain),
            dependencies: [
                .domain(target: .BaseDomain),
                .domain(target: .ChartDomain, type: .interface)
            ]
        ),
        .tests(
            module: .domain(.ChartDomain),
            dependencies: [.domain(target: .ChartDomain)]
        )
    ]
)
