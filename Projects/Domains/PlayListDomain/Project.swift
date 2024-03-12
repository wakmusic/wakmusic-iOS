import DependencyPlugin
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.module(
    name: ModulePaths.Domain.PlayListDomain.rawValue,
    targets: [
        .interface(
            module: .domain(.PlayListDomain),
            dependencies: [
                .domain(target: .BaseDomain, type: .interface),
                .domain(target: .SongsDomain, type: .interface)
            ]
        ),
        .implements(
            module: .domain(.PlayListDomain),
            dependencies: [
                .domain(target: .BaseDomain),
                .domain(target: .SongsDomain),
                .domain(target: .PlayListDomain, type: .interface)
            ]
        ),
        .tests(
            module: .domain(.PlayListDomain),
            dependencies: [.domain(target: .PlayListDomain)]
        )
    ]
)
