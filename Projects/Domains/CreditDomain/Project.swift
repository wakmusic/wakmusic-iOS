import DependencyPlugin
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.module(
    name: ModulePaths.Domain.CreditDomain.rawValue,
    targets: [
        .interface(module: .domain(.CreditDomain)),
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
