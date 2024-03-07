import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.module(
    name: ModulePaths.Domain.BaseDomain.rawValue,
    targets: [
        .implements(
            module: .domain(.BaseDomain),
            product: .staticFramework,
            spec: .init(
                dependencies: [.Project.Module.Utility,
                               .Project.Module.ErrorModule,
                               .Project.Module.KeychainModule,
                               .Project.Module.ThirdPartyLib]
            )
        ),
        .interface(module: .domain(.BaseDomain)),
        .tests(
            module: .domain(.BaseDomain),
            dependencies: [.domain(target: .BaseDomain, type: .interface)]
        )
    ]
)
