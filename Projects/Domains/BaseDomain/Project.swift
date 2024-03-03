import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.module(
    name: ModulePaths.Domain.BaseDomain.rawValue,
    targets: [
        .implements(
            module: .domain(.BaseDomain),
            product: .staticFramework,
            dependencies: [
                .Project.Module.Utility,
                .Project.Module.ErrorModule,
                .Project.Module.KeychainModule,
                .Project.Module.ThirdPartyLib,
                TargetDependency.domain(target: .BaseDomain, type: .interface)
            ]
        ),
        .interface(module: .domain(.BaseDomain)),
        .tests(
            module: .domain(.BaseDomain),
            dependencies: [.domain(target: .BaseDomain)]
        )
    ]
)
