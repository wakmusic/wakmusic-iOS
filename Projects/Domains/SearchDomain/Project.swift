import DependencyPlugin
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.module(
    name: ModulePaths.Domain.SearchDomain.rawValue,
    targets: [
        .interface(module: .domain(.SearchDomain), dependencies: [
            .domain(target: .SongsDomain, type: .interface),
            .domain(target: .BaseDomain, type: .interface)
        ]),
        .implements(module: .domain(.SearchDomain), dependencies: [
            .domain(target: .SearchDomain, type: .interface),
            .domain(target: .BaseDomain)
        ])
    ]
)
