import DependencyPlugin
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.module(
    name: ModulePaths.Domain.BaseDomain.rawValue,
    targets: [
        .interface(module: .domain(.BaseDomain)),
        .implements(
            module: .domain(.BaseDomain),
            dependencies: [
                .Project.Module.Utility,
                .Project.Module.ErrorModule,
                .Project.Module.KeychainModule,
                TargetDependency.domain(target: .BaseDomain, type: .interface)
            ]
        ),
        .tests(
            module: .domain(.BaseDomain),
            dependencies: [.domain(target: .BaseDomain)]
        )
    ]
)
