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
                .domain(target: .SongsDomain, type: .interface),
                .domain(target: .UserDomain, type: .interface),
                .domain(target: .LikeDomain, type: .interface)
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
