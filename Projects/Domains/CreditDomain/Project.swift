import DependencyPlugin
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.module(
    name: ModulePaths.Domain.CreditDomain.rawValue,
    targets: [
        .interface(module: .domain(.CreditDomain), dependencies: [
            .domain(target: .BaseDomain, type: .interface),
            .domain(target: .SongsDomain, type: .interface)
        ]),
        .implements(module: .domain(.CreditDomain), dependencies: [
            .domain(target: .BaseDomain),
            .domain(target: .CreditDomain, type: .interface)
        ]),
        .testing(module: .domain(.CreditDomain), dependencies: [
            .domain(target: .CreditDomain, type: .interface)
        ]),
        .tests(module: .domain(.CreditDomain), dependencies: [
            .domain(target: .CreditDomain)
        ])
    ]
)
