import DependencyPlugin
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.module(
    name: ModulePaths.Domain.ArtistDomain.rawValue,
    targets: [
        .interface(
            module: .domain(.ArtistDomain),
            dependencies: [
                .domain(target: .BaseDomain, type: .interface)
            ]
        ),
        .implements(
            module: .domain(.ArtistDomain),
            dependencies: [
                .domain(target: .BaseDomain),
                .domain(target: .ArtistDomain, type: .interface)
            ]
        ),
        .testing(
            module: .domain(.ArtistDomain),
            dependencies: [.domain(target: .ArtistDomain, type: .interface)]
        ),
        .tests(
            module: .domain(.ArtistDomain),
            dependencies: [.domain(target: .ArtistDomain)]
        )
    ]
)
