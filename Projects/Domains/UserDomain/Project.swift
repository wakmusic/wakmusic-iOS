import DependencyPlugin
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.module(
    name: ModulePaths.Domain.UserDomain.rawValue,
    targets: [
        .interface(module: .domain(.UserDomain)),
        .implements(
            module: .domain(.UserDomain),
            dependencies: [
                .domain(target: .BaseDomain),
                .domain(target: .SongsDomain),
                .domain(target: .UserDomain, type: .interface)
            ]
        ),
        .tests(
            module: .domain(.UserDomain),
            dependencies: [.domain(target: .UserDomain)]
        )
    ]
)
