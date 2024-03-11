import DependencyPlugin
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.module(
    name: ModulePaths.Domain.SongsDomain.rawValue,
    targets: [
        .interface(module: .domain(.SongsDomain)),
        .implements(
            module: .domain(.SongsDomain),
            dependencies: [
                .domain(target: .BaseDomain),
                .domain(target: .SongsDomain, type: .interface)
            ]
        ),
        .tests(
            module: .domain(.SongsDomain),
            dependencies: [.domain(target: .SongsDomain)]
        )
    ]
)
