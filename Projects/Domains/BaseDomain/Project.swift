import DependencyPlugin
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.module(
    name: ModulePaths.Domain.BaseDomain.rawValue,
    targets: [
        .interface(
            module: .domain(.BaseDomain),
            dependencies: [
                .Project.Module.ThirdPartyLib,
                .Project.Module.ErrorModule,
            ]
        ),
        .implements(
            module: .domain(.BaseDomain),
            dependencies: [
                .Project.Module.Utility,
                .Project.Module.KeychainModule,
                .domain(target: .BaseDomain, type: .interface)
            ]
        ),
        .testing(
            module: .domain(.BaseDomain),
            dependencies: [.domain(target: .BaseDomain, type: .interface)]
        ),
        .tests(
            module: .domain(.BaseDomain),
            dependencies: [.domain(target: .BaseDomain)]
        )
    ]
)
