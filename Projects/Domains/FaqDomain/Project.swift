import DependencyPlugin
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.module(
    name: ModulePaths.Domain.FaqDomain.rawValue,
    targets: [
        .interface(module: .domain(.FaqDomain)),
        .implements(
            module: .domain(.FaqDomain),
            dependencies: [
                .domain(target: .BaseDomain),
                .domain(target: .FaqDomain, type: .interface)
            ]
        ),
        .tests(
            module: .domain(.FaqDomain),
            dependencies: [.domain(target: .FaqDomain)]
        )
    ]
)
