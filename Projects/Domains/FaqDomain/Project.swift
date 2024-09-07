import DependencyPlugin
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.module(
    name: ModulePaths.Domain.FaqDomain.rawValue,
    targets: [
        .interface(
            module: .domain(.FaqDomain),
            dependencies: [
                .domain(target: .BaseDomain, type: .interface)
            ]
        ),
        .implements(
            module: .domain(.FaqDomain),
            dependencies: [
                .domain(target: .BaseDomain),
                .domain(target: .FaqDomain, type: .interface)
            ]
        ),
        .testing(
            module: .domain(.FaqDomain),
            dependencies: [.domain(target: .FaqDomain, type: .interface)]
        ),
        .tests(
            module: .domain(.FaqDomain),
            dependencies: [.domain(target: .FaqDomain)]
        )
    ]
)
