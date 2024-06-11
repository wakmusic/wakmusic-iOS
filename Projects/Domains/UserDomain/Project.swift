import DependencyPlugin
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.module(
    name: ModulePaths.Domain.UserDomain.rawValue,
    targets: [
        .interface(
            module: .domain(.UserDomain),
            dependencies: [
                .domain(target: .BaseDomain, type: .interface),
                .domain(target: .SongsDomain, type: .interface)
            ]
        ),
        .implements(
            module: .domain(.UserDomain),
            dependencies: [
                .domain(target: .BaseDomain),
                .domain(target: .SongsDomain),
                .domain(target: .UserDomain, type: .interface)
            ]
        ),
        .testing(
            module: .domain(.UserDomain),
            dependencies: [.domain(target: .UserDomain, type: .interface)]
        ),
        .tests(
            module: .domain(.UserDomain),
            dependencies: [.domain(target: .UserDomain)]
        )
    ]
)
