import DependencyPlugin
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.module(
    name: ModulePaths.Domain.PlayListDomain.rawValue,
    targets: [
        .interface(module: .domain(.PlayListDomain)),
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
