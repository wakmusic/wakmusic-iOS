import DependencyPlugin
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.module(
    name: ModulePaths.Domain.ArtistDomain.rawValue,
    targets: [
        .interface(module: .domain(.ArtistDomain)),
        .implements(
            module: .domain(.ArtistDomain),
            dependencies: [
                .domain(target: .BaseDomain),
                .domain(target: .ArtistDomain, type: .interface)
            ]
        ),
        .tests(
            module: .domain(.ArtistDomain),
            dependencies: [.domain(target: .ArtistDomain)]
        )
    ]
)
