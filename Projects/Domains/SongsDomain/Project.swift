import DependencyPlugin
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.module(
    name: ModulePaths.Domain.SongsDomain.rawValue,
    targets: [
        .interface(
            module: .domain(.SongsDomain),
            dependencies: [
                .domain(target: .BaseDomain, type: .interface)
            ]
        ),
        .implements(
            module: .domain(.SongsDomain),
            dependencies: [
                .domain(target: .BaseDomain),
                .domain(target: .SongsDomain, type: .interface),
                .domain(target: .AuthDomain, type: .interface),
                .domain(target: .LikeDomain, type: .interface)
            ]
        ),
        .testing(
            module: .domain(.SongsDomain),
            dependencies: [
                .domain(target: .SongsDomain, type: .interface)
            ]
        ),
        .tests(
            module: .domain(.SongsDomain),
            dependencies: [.domain(target: .SongsDomain)]
        )
    ]
)
