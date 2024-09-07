import DependencyPlugin
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.module(
    name: ModulePaths.Domain.PlaylistDomain.rawValue,
    targets: [
        .interface(
            module: .domain(.PlaylistDomain),
            dependencies: [
                .domain(target: .BaseDomain, type: .interface),
                .domain(target: .SongsDomain, type: .interface)
            ]
        ),
        .implements(
            module: .domain(.PlaylistDomain),
            dependencies: [
                .domain(target: .BaseDomain),
                .domain(target: .SongsDomain),
                .domain(target: .PlaylistDomain, type: .interface)
            ]
        ),
        .tests(
            module: .domain(.PlaylistDomain),
            dependencies: [.domain(target: .PlaylistDomain)]
        ),
        .testing(module: .domain(.PlaylistDomain), dependencies: [
            .domain(target: .PlaylistDomain, type: .interface)
        ])
    ]
)
