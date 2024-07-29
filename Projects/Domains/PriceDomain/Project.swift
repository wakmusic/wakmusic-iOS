import DependencyPlugin
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.module(
    name: ModulePaths.Domain.PriceDomain.rawValue,
    targets: [
        .interface(module: .domain(.PriceDomain), dependencies: [
            .domain(target: .BaseDomain, type: .interface)
        ]),
        .implements(module: .domain(.PriceDomain), dependencies: [
            .domain(target: .PriceDomain, type: .interface),
            .domain(target: .BaseDomain)
        ])
    ]
)
